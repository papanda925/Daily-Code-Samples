Add-Type -AssemblyName System.Drawing
$g=[Drawing.Graphics]::FromHwnd([IntPtr]::Zero);try{[pscustomobject]@{DpiX=$g.DpiX;DpiY=$g.DpiY;ScalePercent=[math]::Round($g.DpiX/96*100)}}finally{$g.Dispose()}
