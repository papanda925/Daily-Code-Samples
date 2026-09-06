$name="Global\DailyCodeMutexDemo"
$j=1..3|%{Start-Job -ArgumentList $name,$_ {param($n,$id);$m=New-Object Threading.Mutex($false,$n);[void]$m.WaitOne();try{"START $id";Start-Sleep 1;"END $id"}finally{$m.ReleaseMutex();$m.Dispose()}}}
$j|Wait-Job|Receive-Job;$j|Remove-Job
