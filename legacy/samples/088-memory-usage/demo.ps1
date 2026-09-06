function M{$o=Get-CimInstance Win32_OperatingSystem;[pscustomobject]@{UsedGB=[math]::Round(($o.TotalVisibleMemorySize-$o.FreePhysicalMemory)/1MB,2);FreeGB=[math]::Round($o.FreePhysicalMemory/1MB,2)}}
"Before";M;Read-Host "アプリを起動してEnter";"After";M
