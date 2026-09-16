[CmdletBinding()]
param(
    [string]$Filter = '*.txt'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase

# 本番フォルダを誤監視しないよう、TEMP配下の教材専用フォルダを使います。
$watchPath = Join-Path $env:TEMP 'Papanda-FileWatcher-Demo'
New-Item -ItemType Directory -Path $watchPath -Force | Out-Null

# FileSystemWatcher側のイベント処理とUI更新を直接つなげず、
# スレッドセーフなキューを間に置きます。
$eventQueue = [System.Collections.Concurrent.ConcurrentQueue[object]]::new()

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Papanda FileSystemWatcher Demo" Height="430" Width="760">
  <Grid Margin="12">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <TextBlock Name="PathText" FontWeight="Bold" TextWrapping="Wrap"/>
    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,10,0,10">
      <Button Name="CreateButton" Width="150" Margin="0,0,8,0">テストファイルを作る</Button>
      <Button Name="ClearButton" Width="100">表示を消す</Button>
    </StackPanel>
    <ListBox Name="EventList" Grid.Row="2"/>
    <TextBlock Name="StatusText" Grid.Row="3" Margin="0,8,0,0"/>
  </Grid>
</Window>
'@

$reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$pathText = $window.FindName('PathText')
$createButton = $window.FindName('CreateButton')
$clearButton = $window.FindName('ClearButton')
$eventList = $window.FindName('EventList')
$statusText = $window.FindName('StatusText')

$pathText.Text = "監視先: $watchPath    Filter: $Filter"
$statusText.Text = '[START] FileSystemWatcherを準備しています'

$watcher = [System.IO.FileSystemWatcher]::new($watchPath, $Filter)
$watcher.IncludeSubdirectories = $false
$watcher.NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite, Size'

# イベントハンドラーではUIを触らず、観察情報だけキューへ入れます。
$handler = {
    param($sender, $e)
    $eventQueue.Enqueue([pscustomobject]@{
        Time       = Get-Date
        ChangeType = $e.ChangeType
        Name       = $e.Name
    })
}

$watcher.add_Created($handler)
$watcher.add_Changed($handler)
$watcher.add_Deleted($handler)
$watcher.add_Renamed({
    param($sender, $e)
    $eventQueue.Enqueue([pscustomobject]@{
        Time       = Get-Date
        ChangeType = 'Renamed'
        Name       = "$($e.OldName) -> $($e.Name)"
    })
})

# DispatcherTimerはWPFのUIスレッド側で動くため、ここでListBoxを更新します。
$timer = [Windows.Threading.DispatcherTimer]::new()
$timer.Interval = [TimeSpan]::FromMilliseconds(250)
$timer.add_Tick({
    $item = $null
    while ($eventQueue.TryDequeue([ref]$item)) {
        $eventList.Items.Add(
            '[{0:HH:mm:ss.fff}] {1,-8} {2}' -f $item.Time, $item.ChangeType, $item.Name
        ) | Out-Null
        $eventList.ScrollIntoView($eventList.Items[$eventList.Items.Count - 1])
    }
})

$createButton.Add_Click({
    try {
        $name = 'sample-{0:yyyyMMdd-HHmmss-fff}.txt' -f (Get-Date)
        $path = Join-Path $watchPath $name
        "Papanda demo $(Get-Date -Format o)" | Set-Content -LiteralPath $path -Encoding UTF8
        $statusText.Text = "[SUCCESS] テストファイルを作成: $name"
    }
    catch {
        $statusText.Text = "[FAILED] $($_.Exception.Message)"
    }
})

$clearButton.Add_Click({ $eventList.Items.Clear() })

try {
    $watcher.EnableRaisingEvents = $true
    $timer.Start()
    $statusText.Text = '[SUCCESS] 監視開始。テストファイルを作ってイベントを観察してください'
    $window.ShowDialog() | Out-Null
}
finally {
    # ウィンドウを閉じた後も監視が残らないよう、必ず停止・破棄します。
    $timer.Stop()
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    $reader.Close()
}
