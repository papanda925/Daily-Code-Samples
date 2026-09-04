Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Screen]::AllScreens|%{[pscustomobject]@{Device=$_.DeviceName;Primary=$_.Primary;Bounds=$_.Bounds}}
