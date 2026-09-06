Add-Type -AssemblyName System.Windows.Forms
$f=New-Object Windows.Forms.Form; $b=New-Object Windows.Forms.Button; $b.Text="3秒止める"; $b.Dock="Fill"
$b.Add_Click({Write-Host "START";Start-Sleep 3;Write-Host "END"});$f.Controls.Add($b);[void]$f.ShowDialog()
