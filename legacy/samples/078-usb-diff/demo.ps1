function U{Get-CimInstance Win32_PnPEntity|? PNPDeviceID -Like 'USB*'|% PNPDeviceID}
$a=U;Read-Host "USBを抜き差ししてEnter";$b=U;Compare-Object $a $b
