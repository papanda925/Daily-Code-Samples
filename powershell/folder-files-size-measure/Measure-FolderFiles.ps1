# PowerShell 7向け。ファイル・フォルダーの変更は行わない。
# 練習用フォルダーを必ず明示し、存在しなければ停止する。
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $Folder
)
$ErrorActionPreference = 'Stop'

try {
    if (-not (Test-Path -LiteralPath $Folder -PathType Container)) {
        throw "フォルダーが存在しません: $Folder"
    }

    # -Fileでディレクトリを除外。-Recurseを省略し直下だけを対象にする。
    $items = @(Get-ChildItem -LiteralPath $Folder -File -ErrorAction Stop)

    # Sumがnullになる空フォルダーのケースを明示的に0へ変換する。
    $sum = ($items | Measure-Object -Property Length -Sum).Sum
    if ($null -eq $sum) { $sum = 0L }

    # 1MB = 1,048,576バイト。ファイルのディスク割当量ではない。
    [pscustomobject]@{
        Path       = (Resolve-Path -LiteralPath $Folder).Path
        FileCount  = $items.Count
        TotalBytes = [long] $sum
        TotalMiB   = [math]::Round(([double] $sum / 1MB), 2)
        CheckedAt  = (Get-Date).ToString('o')
    }
}
catch {
    # アクセス拒否で一部ファイルだけ集計した値を成功として返さない。
    Write-Error "集計に失敗しました: $($_.Exception.Message)"
    throw
}
