$o=Get-CimInstance Win32_OperatingSystem
[pscustomobject]@{TotalPhysicalGB=[math]::Round($o.TotalVisibleMemorySize/1MB,2);FreePhysicalGB=[math]::Round($o.FreePhysicalMemory/1MB,2);TotalVirtualGB=[math]::Round($o.TotalVirtualMemorySize/1MB,2);FreeVirtualGB=[math]::Round($o.FreeVirtualMemory/1MB,2)}
