$p=Start-Process notepad -PassThru;Start-Sleep -Milliseconds 500;$x=Get-CimInstance Win32_Process -Filter "ProcessId=$($p.Id)"
[pscustomobject]@{ChildPID=$p.Id;ParentPID=$x.ParentProcessId};Stop-Process $p.Id -ErrorAction SilentlyContinue
