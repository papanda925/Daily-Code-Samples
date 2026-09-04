Get-Process -Id $PID|Select-Object Name,Id,PriorityClass,@{N='ThreadCount';E={$_.Threads.Count}}
