#requires -Version 5.1

<#
.SYNOPSIS
    フォルダー内のファイル一覧をCSVへ出力します。

.DESCRIPTION
    指定フォルダー直下にあるファイルについて、
    ファイル名・更新日時・サイズをCSVへ保存します。

    最初は必ずテスト用フォルダーで試してください。
#>

param(
    # 一覧にしたいフォルダー
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,

    # 作成するCSVファイル
    [Parameter(Mandatory = $true)]
    [string]$OutputCsv
)

# フォルダーが存在するか先に確認します。
if (-not (Test-Path -LiteralPath $FolderPath -PathType Container)) {
    Write-Error "フォルダーが見つかりません: $FolderPath"
    exit 1
}

# -File を付けることで、フォルダーではなくファイルだけを対象にします。
$files = Get-ChildItem -LiteralPath $FolderPath -File

# Excelで確認しやすい3項目に絞ります。
$files |
    Select-Object Name, LastWriteTime, Length |
    Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding UTF8

Write-Host "ファイル一覧を作成しました。"
Write-Host "出力先: $OutputCsv"
Write-Host "件数    : $($files.Count)"
