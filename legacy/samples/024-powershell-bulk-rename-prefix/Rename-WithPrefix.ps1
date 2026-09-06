#requires -Version 5.1
param(
    [Parameter(Mandatory=$true)][string]$FolderPath,
    [Parameter(Mandatory=$true)][string]$Prefix,
    [switch]$Apply
)

if (-not (Test-Path -LiteralPath $FolderPath -PathType Container)) {
    Write-Error "フォルダーが見つかりません: $FolderPath"
    exit 1
}

Get-ChildItem -LiteralPath $FolderPath -File | ForEach-Object {
    $newName = $Prefix + $_.Name

    # 既定では WhatIf 相当の確認表示だけにします。
    if (-not $Apply) {
        Write-Host "[確認のみ] $($_.Name) -> $newName"
        return
    }

    # -Apply を明示したときだけ実際に名前を変更します。
    Rename-Item -LiteralPath $_.FullName -NewName $newName
}
