Add-Type -AssemblyName System.Windows.Forms
$f=New-Object Windows.Forms.Form;$f.Add_MouseDown({Write-Host "Down $($_.Button) $($_.Location)"});$f.Add_MouseUp({Write-Host "Up $($_.Button) $($_.Location)"});$f.Add_Click({Write-Host Click});[void]$f.ShowDialog()
