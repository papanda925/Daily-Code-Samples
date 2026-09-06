1..10|%{$b=Get-CimInstance Win32_Battery -EA 0;if(!$b){"Battery情報なし";break};"$(Get-Date -Format HH:mm:ss) Charge=$($b.EstimatedChargeRemaining)% Status=$($b.BatteryStatus)";Start-Sleep 2}
