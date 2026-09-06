$timer=New-Object Timers.Timer 1000
$s=Register-ObjectEvent $timer Elapsed -Action{Write-Host "Tick $(Get-Date -Format HH:mm:ss.fff)"}
$timer.Start();Start-Sleep 5;$timer.Stop();Unregister-Event $s.Name;$timer.Dispose()
