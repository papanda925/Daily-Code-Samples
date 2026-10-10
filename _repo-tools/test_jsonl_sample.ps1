# Executes the current JSONL sample with a throwaway temp file (PowerShell 7 CI).
# A separate Windows PowerShell 5.1 host test remains required before claiming PS5.1 verified.
$ErrorActionPreference = 'Stop'
$sample = Join-Path $PSScriptRoot '..'
$sample = Join-Path $sample 'powershell/jsonl-event-log/Write-ReadJsonlDemo.ps1'
# The .ps1 source contains Japanese string literals. WinPS 5.1 needs a UTF-8 BOM
# to read the script from disk correctly (the resulting .jsonl must still have no BOM).
$scriptBytes = [IO.File]::ReadAllBytes($sample)
if ($scriptBytes.Length -lt 3 -or $scriptBytes[0] -ne 0xEF -or
    $scriptBytes[1] -ne 0xBB -or $scriptBytes[2] -ne 0xBF) {
    throw 'Source .ps1 with Japanese text must use UTF-8 BOM for WinPS 5.1.'
}
$messages = @(& $sample -KeepFiles 3>&1 | ForEach-Object { [string]$_ })

if (-not ($messages -match '^\[RESULT\] valid=2 invalid=1$')) {
    throw "Unexpected summary from JSONL sample: $($messages -join ' | ')"
}
if (-not ($messages -match '^\[OK\] line=1 event_id=evt-001 status=START$')) {
    throw 'Missing first parsed event.'
}
if (-not ($messages -match '^\[OK\] line=2 event_id=evt-002 status=DONE$')) {
    throw 'Missing second parsed event.'
}

$fileMarker = @($messages | Where-Object { $_ -match '^\[FILE\] ' })
if ($fileMarker.Count -ne 1) { throw 'Expected exactly one output file marker.' }
$logFile = ($fileMarker[0] -replace '^\[FILE\] ', '').Trim()
$logFull = [IO.Path]::GetFullPath($logFile)
$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$folder = [IO.Path]::GetDirectoryName($logFull)
if (-not ($logFull.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase))) {
    throw 'Refuse to inspect/cleanup a file outside system temp.'
}
if (-not ([IO.Path]::GetFileName($folder) -match '^jsonl-demo-[0-9a-f]{32}$')) {
    throw 'Refuse to cleanup an unexpected temp folder.'
}
try {
    $bytes = [IO.File]::ReadAllBytes($logFull)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        throw 'JSONL contains a UTF-8 BOM.'
    }
    $lines = [IO.File]::ReadAllLines($logFull, [Text.UTF8Encoding]::new($false))
    if ($lines.Length -ne 3) { throw "Expected 3 JSONL lines; received $($lines.Length)." }
    if ($lines[2] -ne '{broken json') { throw 'The teaching invalid line was lost.' }
    $records = @($lines[0..1] | ForEach-Object { ConvertFrom-Json -InputObject $_ -ErrorAction Stop })
    if ($records[0].event_id -ne 'evt-001' -or $records[1].event_id -ne 'evt-002') {
        throw 'Unexpected JSON event data.'
    }
    if ($records[0].message -ne '開始' -or $records[1].message -ne '完了') {
        throw 'UTF-8 Japanese payload did not round trip.'
    }
    Write-Output 'JSONL_SAMPLE_TEST_OK rows=3 valid=2 invalid=1 utf8_bom=false'
}
finally {
    if (Test-Path -LiteralPath $folder) {
        Remove-Item -LiteralPath $folder -Recurse -Force
    }
}
