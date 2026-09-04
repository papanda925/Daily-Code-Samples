"Before";Get-CimInstance Win32_SoundDevice|Select Name,Status;Read-Host "GUIで出力先を切替えてEnter";"After";Get-CimInstance Win32_SoundDevice|Select Name,Status
