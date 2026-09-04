Get-CimInstance Win32_PnPEntity|? PNPDeviceID -Like 'USB*'|Select-Object Name,Status,Manufacturer,PNPDeviceID
