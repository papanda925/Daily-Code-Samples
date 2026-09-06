function M{[math]::Round((Get-Process -Id $PID).WorkingSet64/1MB,1)}
"Before $(M)MB";$data=New-Object byte[](100MB);"Allocated $(M)MB";Remove-Variable data;[GC]::Collect();[GC]::WaitForPendingFinalizers();"AfterGC $(M)MB"
