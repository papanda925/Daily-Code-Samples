Get-CimInstance Win32_PnPEntity|?{$_.PNPClass-eq'Bluetooth'-or$_.Name-match'Bluetooth'}|Select Name,Status,PNPDeviceID
