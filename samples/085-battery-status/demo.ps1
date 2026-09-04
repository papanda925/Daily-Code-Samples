$b=Get-CimInstance Win32_Battery -EA 0;if($b){$b|Select Name,EstimatedChargeRemaining,BatteryStatus,EstimatedRunTime}else{"Battery情報なし"}
