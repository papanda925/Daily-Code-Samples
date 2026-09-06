"このPowerShellのPID = $PID"
Get-Process -Id $PID | Select-Object Name,Id,StartTime,Handles,Threads
