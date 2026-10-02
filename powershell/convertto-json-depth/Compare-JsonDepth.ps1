Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$data = [pscustomobject]@{
  Name='demo'
  Settings=[pscustomobject]@{
    Network=[pscustomobject]@{
      Proxy=[pscustomobject]@{Enabled=$false;Port=8080}
    }
  }
}
try {
  foreach($depth in 2,5) {
    Write-Host "[START] Depth=$depth"
    $json=$data | ConvertTo-Json -Depth $depth -Compress
    Write-Host "[RESULT] $json"
  }
  Write-Host "[SUCCESS] Compare Depth=2 and Depth=5"
} catch { Write-Error "[FAILED] $($_.Exception.Message)"; exit 1 }
