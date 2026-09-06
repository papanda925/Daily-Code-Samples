Get-CimInstance Win32_PnPEntity|? Name|Select-Object -First 25 Name,PNPClass,PNPDeviceID
