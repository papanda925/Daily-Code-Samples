1..30|%{$x=netsh wlan show interfaces;$s=$x|Select-String '^\s*SSID\s*:'|Select -First 1;$b=$x|Select-String '^\s*BSSID\s*:'|Select -First 1;"$(Get-Date -Format HH:mm:ss) | $s | $b";Start-Sleep 2}
