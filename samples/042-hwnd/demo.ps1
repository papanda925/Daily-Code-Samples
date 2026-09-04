Get-Process | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 20 Name,Id,@{Name='HWND';Expression={'0x{0:X}' -f $_.MainWindowHandle}},MainWindowTitle
