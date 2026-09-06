if($PSVersionTable.PSVersion.Major-lt7){throw'PowerShell 7 required'};1..4|ForEach-Object -Parallel {Start-Sleep 1;"done $_"} -ThrottleLimit 4
