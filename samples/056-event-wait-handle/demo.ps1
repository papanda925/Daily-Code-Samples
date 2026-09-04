$name="Global\DailyCodeEventDemo";$e=New-Object Threading.EventWaitHandle($false,[Threading.EventResetMode]::AutoReset,$name)
$j=Start-Job -ArgumentList $name {param($n);$x=[Threading.EventWaitHandle]::OpenExisting($n);"WAIT";[void]$x.WaitOne();"GO";$x.Dispose()}
Start-Sleep 2;"SET";$e.Set()|Out-Null;$j|Wait-Job|Receive-Job;$j|Remove-Job;$e.Dispose()
