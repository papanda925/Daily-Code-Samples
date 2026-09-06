Add-Type @'
using System;using System.Runtime.InteropServices;public static class C{[StructLayout(LayoutKind.Sequential)]public struct P{public int X,Y;}[DllImport("user32.dll")]public static extern bool GetCursorPos(out P p);}
'@
1..30|%{$p=New-Object C+P;[void][C]::GetCursorPos([ref]$p);[Console]::Write(("X={0} Y={1}   "-f$p.X,$p.Y)+[char]13);Start-Sleep -Milliseconds 200}
