Get-Process|? MainWindowHandle -ne 0|Select Name,Id,MainWindowTitle,@{N='HWND';E={'0x{0:X}'-f$_.MainWindowHandle}}
