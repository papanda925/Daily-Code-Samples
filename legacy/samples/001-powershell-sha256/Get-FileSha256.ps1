#requires -Version 5.1

<#
.SYNOPSIS
    ファイルの「指紋（SHA-256）」を確認します。

.DESCRIPTION
    指定したファイルの内容からSHA-256という値を計算します。

    難しく考えなくて大丈夫です。
    同じ内容のファイルなら、基本的に同じ値になります。

    このスクリプトはファイルを読み取るだけです。
    ファイルの内容を書き換えたり、削除したりはしません。

.EXAMPLE
    .\Get-FileSha256.ps1 -Path "C:\Temp\sample.txt"
#>

param(
    # 確認したいファイルの場所を指定します。
    # 例: C:\Temp\sample.txt
    [Parameter(Mandatory = $true)]
    [string]$Path
)

# ------------------------------------------------------------
# 1. ファイルが本当にあるか確認
# ------------------------------------------------------------
# 入力ミスのまま処理を続けると分かりにくいので、
# 最初に「その場所に何かあるか」を確認します。
if (-not (Test-Path -LiteralPath $Path)) {
    Write-Host ""
    Write-Host "ファイルが見つかりません。" -ForegroundColor Yellow
    Write-Host "指定した場所: $Path"
    Write-Host ""
    Write-Host "ファイルの場所と名前をもう一度確認してください。"
    exit 1
}

# ------------------------------------------------------------
# 2. Windowsが認識している正式なファイルの場所を取得
# ------------------------------------------------------------
$resolvedPath = (Resolve-Path -LiteralPath $Path).Path

# ------------------------------------------------------------
# 3. 間違ってフォルダを指定していないか確認
# ------------------------------------------------------------
$item = Get-Item -LiteralPath $resolvedPath

if ($item.PSIsContainer) {
    Write-Host ""
    Write-Host "フォルダではなく、確認したいファイルを指定してください。" -ForegroundColor Yellow
    Write-Host "指定した場所: $resolvedPath"
    exit 1
}

# ------------------------------------------------------------
# 4. ファイルの「指紋」を計算
# ------------------------------------------------------------
# Get-FileHash はPowerShellに標準で用意されている機能です。
# ファイルを書き換える処理ではありません。
$hashResult = Get-FileHash -LiteralPath $resolvedPath -Algorithm SHA256

# ------------------------------------------------------------
# 5. 結果を見やすく表示
# ------------------------------------------------------------
Write-Host ""
Write-Host "=== ファイル確認結果 ==="
Write-Host ""
Write-Host "ファイル : $resolvedPath"
Write-Host "方式     : $($hashResult.Algorithm)"
Write-Host "指紋     : $($hashResult.Hash)"
Write-Host ""
Write-Host "別のファイルも確認し、「指紋」が同じか比べてみてください。"
