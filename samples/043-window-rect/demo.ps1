Add-Type @'
using System; using System.Runtime.InteropServices;
public static class Win32Rect {
 [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left,Top,Right,Bottom; }
 [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd,out RECT rect);
}
'@
$p=Start-Process notepad -PassThru; Start-Sleep -Milliseconds 800
$r=New-Object Win32Rect+RECT; [void][Win32Rect]::GetWindowRect($p.MainWindowHandle,[ref]$r)
[pscustomobject]@{Left=$r.Left;Top=$r.Top;Width=$r.Right-$r.Left;Height=$r.Bottom-$r.Top}
Stop-Process -Id $p.Id -ErrorAction SilentlyContinue
