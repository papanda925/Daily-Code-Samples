1..8|%{$c=(Get-CimInstance Win32_Processor|Measure LoadPercentage -Average).Average;"$(Get-Date -Format HH:mm:ss) CPU=$c%";Start-Sleep 1}
