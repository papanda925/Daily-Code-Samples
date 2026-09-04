Add-Type @'
using System; using System.Runtime.InteropServices;
public static class Win32Msg { [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd,uint Msg,IntPtr wParam,IntPtr lParam); }
'@
$WM_CLOSE=0x0010; $p=Start-Process notepad -PassThru; Start-Sleep -Milliseconds 800
[void][Win32Msg]::PostMessage($p.MainWindowHandle,$WM_CLOSE,[IntPtr]::Zero,[IntPtr]::Zero)
Start-Sleep 1; "WM_CLOSE後 HasExited=$($p.HasExited)"
