$ErrorActionPreference = 'Stop'

function Show-Bits([int]$Value) {
    return [Convert]::ToString($Value, 2).PadLeft(8, '0')
}

$Read = 1
$Write = 2
$Execute = 4

Write-Host '[START] 1 / 2 / 4 をビットとして重ねます'
Write-Host ("[FLAG] Read    = {0} ({1})" -f $Read, (Show-Bits $Read))
Write-Host ("[FLAG] Write   = {0} ({1})" -f $Write, (Show-Bits $Write))
Write-Host ("[FLAG] Execute = {0} ({1})" -f $Execute, (Show-Bits $Execute))

$flags = $Read -bor $Execute
Write-Host ("[RESULT] Read -bor Execute = {0} ({1})" -f $flags, (Show-Bits $flags))

foreach ($item in @(
    @{ Name = 'Read'; Value = $Read },
    @{ Name = 'Write'; Value = $Write },
    @{ Name = 'Execute'; Value = $Execute }
)) {
    $enabled = (($flags -band $item.Value) -ne 0)
    Write-Host ("[CHECK] {0,-7} enabled = {1}" -f $item.Name, $enabled)
}

if (($flags -band $Read) -and -not ($flags -band $Write) -and ($flags -band $Execute)) {
    Write-Host '[SUCCESS] ORで複数bitを立て、ANDで個別bitを判定できました'
}
else {
    Write-Error '[FAILED] 期待したbit判定になりませんでした'
    exit 1
}

Write-Host '[TRY] $flags = $Read -bor $Write -bor $Execute に変えると2進数がどうなるか予想してください'
