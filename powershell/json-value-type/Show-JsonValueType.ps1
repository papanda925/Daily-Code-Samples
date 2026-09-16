[CmdletBinding()]
param(
    [switch]$UseStringPort
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# まずは外部ファイルを使わず、壊しても困らないダミーJSONで観察します。
$portValue = if ($UseStringPort) { '"443"' } else { '443' }

$json = @"
{
  "service": "demo",
  "port": $portValue,
  "enabled": true,
  "retry": 3,
  "note": null
}
"@

try {
    $config = $json | ConvertFrom-Json

    foreach ($property in $config.PSObject.Properties) {
        $value = $property.Value
        $typeName = if ($null -eq $value) {
            '<null>'
        }
        else {
            $value.GetType().FullName
        }

        [pscustomobject]@{
            Name     = $property.Name
            Value    = $value
            Type     = $typeName
        }
    }

    # 実務でありがちな「portは数値のはず」を簡単に検証します。
    if ($config.port -is [int] -or $config.port -is [long]) {
        '[SUCCESS] port is numeric'
    }
    else {
        "[FAILED] port is not numeric. ActualType=$($config.port.GetType().FullName)"
    }
}
catch {
    "[FAILED] JSON parse/check error: $($_.Exception.Message)"
    throw
}
