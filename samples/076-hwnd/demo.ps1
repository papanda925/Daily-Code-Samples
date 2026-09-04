Add-Type @'
using System;using System.Text;using System.Runtime.InteropServices;
public static class FG{[DllImport("user32.dll")]public static extern IntPtr GetForegroundWindow();[DllImport("user32.dll",CharSet=CharSet.Unicode)]public static extern int GetWindowText(IntPtr h,StringBuilder s,int c);}
'@
1..10|%{$h=[FG]::GetForegroundWindow();$s=[Text.StringBuilder]::new(256);[void][FG]::GetWindowText($h,$s,$s.Capacity);"{0} HWND=0x{1:X} {2}"-f(Get-Date -Format HH:mm:ss),$h.ToInt64(),$s;Start-Sleep 1}
