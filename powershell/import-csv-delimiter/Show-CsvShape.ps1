param([char]$Delimiter = ';')
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$path = Join-Path $env:TEMP 'papanda-importcsv-demo.csv'
try {
@'
Name;Count
A;10
B;20
'@ | Set-Content -LiteralPath $path -Encoding utf8
  $data = @(Import-Csv -LiteralPath $path -Delimiter $Delimiter)
  if ($data.Count -eq 0) { throw 'データ行がありません。' }
  $names = @($data[0].PSObject.Properties.Name)
  [pscustomobject]@{ Success=$true; Delimiter=$Delimiter; RowCount=$data.Count; PropertyCount=$names.Count; PropertyNames=($names -join ', ') }
  Write-Host "[SUCCESS] rows=$($data.Count) properties=$($names.Count)"
} catch {
  Write-Error "[FAILED] $($_.Exception.Message)"
} finally {
  Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
}
