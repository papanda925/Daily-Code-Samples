$o=Get-CimInstance Win32_OperatingSystem
[pscustomobject]@{LastBoot=$o.LastBootUpTime;Uptime=(Get-Date)-$o.LastBootUpTime}
