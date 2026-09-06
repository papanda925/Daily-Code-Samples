$p=Start-Process notepad -PassThru;$p.EnableRaisingEvents=$true
$s=Register-ObjectEvent $p Exited -Action{Write-Host "Notepad exited $(Get-Date)"}
"メモ帳を閉じてください PID=$($p.Id)";$p.WaitForExit();Start-Sleep -Milliseconds 200;Unregister-Event $s.Name
