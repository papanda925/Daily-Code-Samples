$ErrorActionPreference = 'Stop'

Write-Host '[START] PowerShell + XAML の最小GUIを起動します'

try {
    if ($env:OS -ne 'Windows_NT') {
        throw 'WPFはWindows専用です。'
    }

    $apartment = [Threading.Thread]::CurrentThread.ApartmentState
    Write-Host ("[CHECK] ApartmentState = {0}" -f $apartment)
    if ($apartment -ne 'STA') {
        throw 'WPFサンプルはSTAで実行してください。powershell.exe -STA -File .\Show-MinimalXamlWindow.ps1 を使用します。'
    }

    Add-Type -AssemblyName PresentationFramework

    [xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="papanda XAML Smoke Test"
        Width="420" Height="220"
        WindowStartupLocation="CenterScreen">
  <StackPanel Margin="20">
    <TextBlock Text="文字を入力してボタンを押してください" Margin="0,0,0,8" />
    <TextBox Name="InputText" Height="28" Margin="0,0,0,12" />
    <Button Name="RunButton" Content="PowerShellへイベントを送る" Height="34" />
    <TextBlock Name="ResultText" Margin="0,16,0,0" TextWrapping="Wrap" />
  </StackPanel>
</Window>
'@

    $reader = [System.Xml.XmlNodeReader]::new($xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    $inputText = $window.FindName('InputText')
    $runButton = $window.FindName('RunButton')
    $resultText = $window.FindName('ResultText')

    if (-not $inputText -or -not $runButton -or -not $resultText) {
        throw 'XAML内の名前付き要素を取得できませんでした。'
    }

    $runButton.Add_Click({
        $value = $inputText.Text
        if ([string]::IsNullOrWhiteSpace($value)) {
            $resultText.Text = '[RESULT] 文字を1つ入力してください'
            Write-Host '[RESULT] 入力が空でした'
            return
        }

        $resultText.Text = "[SUCCESS] PowerShell側で受信: $value"
        Write-Host '[SUCCESS] ClickイベントがPowerShellのイベントハンドラへ届きました'
        Write-Host ("[RESULT] Text = {0}" -f $value)
    })

    Write-Host '[READY] 画面を表示します。ボタンを押すとイベント結果がコンソールにも出ます'
    [void]$window.ShowDialog()
    Write-Host '[END] ウィンドウを閉じました'
}
catch {
    Write-Error '[FAILED] XAML/WPF Smoke Test に失敗しました'
    Write-Error ("Type    : {0}" -f $_.Exception.GetType().FullName)
    Write-Error ("Message : {0}" -f $_.Exception.Message)
    exit 1
}
