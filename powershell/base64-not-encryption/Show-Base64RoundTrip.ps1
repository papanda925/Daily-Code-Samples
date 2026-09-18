Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$text = 'papanda-demo-123'

try {
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    $base64 = [Convert]::ToBase64String($bytes)
    $decodedBytes = [Convert]::FromBase64String($base64)
    $decoded = [Text.Encoding]::UTF8.GetString($decodedBytes)

    [pscustomobject]@{
        Original = $text
        Base64  = $base64
        Decoded = $decoded
        Same    = ($text -eq $decoded)
    } | Format-List

    if ($text -ne $decoded) { throw 'Round-trip mismatch' }
    Write-Host '[SUCCESS] Base64 was decoded without an encryption key.'
}
catch {
    Write-Error "[FAILED] $($_.Exception.Message)"
    exit 1
}
