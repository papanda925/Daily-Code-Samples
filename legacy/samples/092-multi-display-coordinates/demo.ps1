Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Screen]::AllScreens|%{[pscustomobject]@{Device=$_.DeviceName;X=$_.Bounds.X;Y=$_.Bounds.Y;Width=$_.Bounds.Width;Height=$_.Bounds.Height}}
