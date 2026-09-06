Add-Type -AssemblyName System.Windows.Forms
$f=New-Object Windows.Forms.Form; $f.Text="Message Loop Lab"
$b=New-Object Windows.Forms.Button; $b.Text="Click"; $b.Dock="Fill"
$b.Add_Click({Write-Host "$(Get-Date -Format HH:mm:ss.fff) Click event"}); $f.Controls.Add($b); [void]$f.ShowDialog()
