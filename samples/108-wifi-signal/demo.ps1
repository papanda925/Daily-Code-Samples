1..15|%{$x=netsh wlan show interfaces;$s=$x|Select-String '^\s*(Signal|シグナル)\s*:'|Select -First 1;"$(Get-Date -Format HH:mm:ss) $s";Start-Sleep 1}
