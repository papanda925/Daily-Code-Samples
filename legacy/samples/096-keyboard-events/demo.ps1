Add-Type -AssemblyName System.Windows.Forms
$f=New-Object Windows.Forms.Form;$f.KeyPreview=$true;$f.Add_KeyDown({Write-Host "KeyDown $($_.KeyCode)"});$f.Add_KeyUp({Write-Host "KeyUp $($_.KeyCode)"});[void]$f.ShowDialog()
