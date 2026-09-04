Add-Type @'
using System;using System.Runtime.InteropServices;public static class NativeDemo{[DllImport("user32.dll")]public static extern int GetSystemMetrics(int nIndex);}
'@
[pscustomobject]@{ScreenWidth=[NativeDemo]::GetSystemMetrics(0);ScreenHeight=[NativeDemo]::GetSystemMetrics(1)}
