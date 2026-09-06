$p=Get-Process -Id $PID
[pscustomobject]@{Process=$p.ProcessName;PID=$p.Id;ThreadCount=$p.Threads.Count}
$p.Threads|Select-Object -First 10 Id,ThreadState,PriorityLevel
