# Windowsの電源状態を変更せず、Win32 APIから読み取ります。
Add-Type @'
using System.Runtime.InteropServices;
public static class PowerStatusNative {
  [StructLayout(LayoutKind.Sequential)]
  public struct SYSTEM_POWER_STATUS {
    public byte ACLineStatus; public byte BatteryFlag; public byte BatteryLifePercent; public byte SystemStatusFlag;
    public uint BatteryLifeTime; public uint BatteryFullLifeTime;
  }
  [DllImport("kernel32.dll", SetLastError=true)]
  public static extern bool GetSystemPowerStatus(out SYSTEM_POWER_STATUS s);
}
'@

$s = New-Object PowerStatusNative+SYSTEM_POWER_STATUS
if (-not [PowerStatusNative]::GetSystemPowerStatus([ref]$s)) {
    $code = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    throw "GetSystemPowerStatus failed. Win32Error=$code"
}

$battery = if ($s.BatteryLifePercent -eq 255) { 'Unknown' } else { "$($s.BatteryLifePercent)%" }
[pscustomobject]@{
    ACLineStatus = $s.ACLineStatus
    Battery      = $battery
    BatteryFlag  = $s.BatteryFlag
}
