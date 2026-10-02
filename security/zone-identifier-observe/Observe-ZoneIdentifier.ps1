param([Parameter(Mandatory=$true)][string]$Path)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
try {
 if(-not (Test-Path -LiteralPath $Path -PathType Leaf)){throw "File not found: $Path"}
 $zone=Get-Item -LiteralPath $Path -Stream * | Where-Object Stream -eq 'Zone.Identifier'
 if($zone){Write-Host "[SUCCESS] Zone.Identifier found";Get-Content -LiteralPath $Path -Stream Zone.Identifier}
 else{Write-Host "[SUCCESS] Zone.Identifier not present"}
} catch {Write-Error "[FAILED] $($_.Exception.Message)";exit 1}
