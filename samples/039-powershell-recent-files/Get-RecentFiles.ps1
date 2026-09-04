#requires -Version 5.1
param(
    [Parameter(Mandatory=$true)][string]$FolderPath,
    [int]$Days = 7
)

$since = (Get-Date).AddDays(-$Days)

# 読み取りだけです。最近更新されたファイルを新しい順に表示します。
Get-ChildItem -LiteralPath $FolderPath -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $since } |
    Sort-Object LastWriteTime -Descending |
    Select-Object LastWriteTime, Name, FullName
