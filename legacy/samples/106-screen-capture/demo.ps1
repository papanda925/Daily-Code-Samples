Add-Type -AssemblyName System.Drawing
$p=Join-Path $env:TEMP 'dailycode-capture.png';$b=New-Object Drawing.Bitmap 400,250;$g=[Drawing.Graphics]::FromImage($b);try{$g.CopyFromScreen(0,0,0,0,$b.Size);$b.Save($p,[Drawing.Imaging.ImageFormat]::Png);"保存=$p"}finally{$g.Dispose();$b.Dispose()}
