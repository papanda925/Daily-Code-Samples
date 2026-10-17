# PowerShell 7.x。指定した2ファイルを読むだけで、更新・削除しない。
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$First,
    [Parameter(Mandatory=$true)][string]$Second
)
$ErrorActionPreference = 'Stop'
foreach ($path in @($First,$Second)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "ファイルが見つかりません: $path"
    }
}
# 拡張子やファイル名ではなく、ファイル内容のSHA256を取得。
$a = Get-FileHash -LiteralPath $First -Algorithm SHA256 -ErrorAction Stop
$b = Get-FileHash -LiteralPath $Second -Algorithm SHA256 -ErrorAction Stop

[pscustomobject]@{
    FirstHash = $a.Hash
    SecondHash = $b.Hash
    SameContentHash = ($a.Hash -eq $b.Hash)
    Algorithm = 'SHA256'
}
