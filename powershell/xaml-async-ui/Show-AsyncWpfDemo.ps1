Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore

# WPFはUIスレッドで動きます。長い処理をClickイベント内で直接実行すると、
# 描画やマウス操作も同じスレッドで待たされるため画面が固まって見えます。
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="PowerShell Async UI Demo" Height="180" Width="440"
        WindowStartupLocation="CenterScreen">
  <StackPanel Margin="16">
    <Button Name="RunButton" Height="34" Content="3秒の処理を開始" />
    <TextBlock Name="StatusText" Margin="0,14,0,0" TextWrapping="Wrap">[READY]</TextBlock>
  </StackPanel>
</Window>
'@

$reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$runButton = $window.FindName('RunButton')
$statusText = $window.FindName('StatusText')

# 別PowerShellパイプラインの状態を保持します。
$script:worker = $null
$script:asyncResult = $null

# DispatcherTimer自体はUIスレッドで短い確認処理だけを実行します。
# 重い処理をTimerのTickへ入れると、結局UIを止めるので注意します。
$timer = [Windows.Threading.DispatcherTimer]::new()
$timer.Interval = [TimeSpan]::FromMilliseconds(200)

$timer.Add_Tick({
    if ($null -eq $script:asyncResult -or -not $script:asyncResult.IsCompleted) {
        return
    }

    $timer.Stop()

    try {
        # EndInvokeは完了後に呼ぶため、ここでは長時間UIをブロックしません。
        $result = $script:worker.EndInvoke($script:asyncResult)
        $statusText.Text = "[SUCCESS] $($result -join ', ')"
    }
    catch {
        $statusText.Text = "[FAILED] $($_.Exception.Message)"
    }
    finally {
        # PowerShellオブジェクトはネイティブ/管理リソースを保持するため破棄します。
        if ($null -ne $script:worker) {
            $script:worker.Dispose()
        }
        $script:worker = $null
        $script:asyncResult = $null
        $runButton.IsEnabled = $true
    }
})

$runButton.Add_Click({
    if ($null -ne $script:asyncResult) {
        return
    }

    $runButton.IsEnabled = $false
    $statusText.Text = '[START] バックグラウンド処理を開始。ウィンドウを動かしてみてください。'

    $script:worker = [PowerShell]::Create()

    # 実験なので安全な疑似処理として3秒待機します。
    # 実務では、この部分を読み取り専用のファイル集計やAPI待機などへ置き換えます。
    [void]$script:worker.AddScript({
        Start-Sleep -Seconds 3
        "完了時刻: $(Get-Date -Format 'HH:mm:ss')"
    })

    try {
        # BeginInvokeは処理の完了を待たずに戻るため、UIスレッドを占有しません。
        $script:asyncResult = $script:worker.BeginInvoke()
        $timer.Start()
    }
    catch {
        $statusText.Text = "[FAILED] $($_.Exception.Message)"
        $script:worker.Dispose()
        $script:worker = $null
        $script:asyncResult = $null
        $runButton.IsEnabled = $true
    }
})

$window.Add_Closed({
    $timer.Stop()

    # ウィンドウを閉じた時に処理が残っていたら、可能な範囲で停止して破棄します。
    if ($null -ne $script:worker) {
        try { $script:worker.Stop() } catch { }
        $script:worker.Dispose()
        $script:worker = $null
        $script:asyncResult = $null
    }
})

[void]$window.ShowDialog()
