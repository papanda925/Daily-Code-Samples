#requires -Version 5.1
param(
    [Parameter(Mandatory=$true)][string]$FolderPath,
    [int]$Top = 20
)

if (-not (Test-Path -LiteralPath $FolderPath -PathType Container)) {
    Write-Error "フォルダーが見つかりません: $FolderPath"
    exit 1
}

# 読み取りだけです。ファイルの削除・変更は行いません。
Get-ChildItem -LiteralPath $FolderPath -File -Recurse -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending |
    Select-Object -First $Top Name,
        @{Name='SizeMB';Expression={[math]::Round($_.Length / 1MB, 2)}},
        FullName
