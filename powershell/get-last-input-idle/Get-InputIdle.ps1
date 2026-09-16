[CmdletBinding()]
param(
    [ValidateSet('Seconds', 'Minutes')]
    [string]$Unit = 'Seconds'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# GetLastInputInfo は user32.dll のWin32 APIです。
# PowerShellから直接呼べないため、最小限のC#宣言をAdd-Typeで用意します。
if (-not ('Papanda.InputIdle.NativeMethods' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

namespace Papanda.InputIdle
{
    public static class NativeMethods
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct LASTINPUTINFO
        {
            public uint cbSize;
            public uint dwTime;
        }

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);
    }
}
'@
}

try {
    $info = New-Object Papanda.InputIdle.NativeMethods+LASTINPUTINFO

    # Win32 APIへ構造体サイズを知らせます。
    # cbSizeを設定しないとAPIが期待する構造体として扱えません。
    $info.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($info)

    $ok = [Papanda.InputIdle.NativeMethods]::GetLastInputInfo([ref]$info)
    if (-not $ok) {
        $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "GetLastInputInfo returned false. Win32Error=$errorCode"
    }

    # dwTime は32bit tick値です。現在値との差を同じ32bit空間で計算すると、
    # TickCountのwrap-aroundを含めた差分として扱いやすくなります。
    $now32 = [uint32]([Environment]::TickCount64 -band 0xFFFFFFFFL)
    $idleMilliseconds = [uint32]($now32 - $info.dwTime)

    $value = switch ($Unit) {
        'Seconds' { $idleMilliseconds / 1000.0 }
        'Minutes' { $idleMilliseconds / 60000.0 }
    }

    [pscustomobject]@{
        Success          = $true
        Unit             = $Unit
        Value            = [math]::Round($value, 2)
        IdleMilliseconds = [uint64]$idleMilliseconds
        LastInputTick    = [uint32]$info.dwTime
        CurrentTick32    = $now32
    }

    "[SUCCESS] Idle$Unit = {0:N2}" -f $value
}
catch {
    "[FAILED] $($_.Exception.Message)"
    throw
}
