$pathA = '.\fileA.txt'
$pathB = '.\fileB.txt'

foreach ($path in @($pathA, $pathB)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "File not found: $path"
    }
}

$a = Get-FileHash -LiteralPath $pathA -Algorithm SHA256
$b = Get-FileHash -LiteralPath $pathB -Algorithm SHA256

[pscustomobject]@{
    FileA = $a.Path
    FileB = $b.Path
    HashA = $a.Hash
    HashB = $b.Hash
    Same  = ($a.Hash -eq $b.Hash)
}
