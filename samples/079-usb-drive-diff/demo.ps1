function D{Get-CimInstance Win32_LogicalDisk|Select DeviceID,DriveType,VolumeName}
$a=D;$a;Read-Host "USBメモリを挿してEnter";$b=D;Compare-Object $a.DeviceID $b.DeviceID;$b
