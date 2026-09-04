#requires -Version 5.1

<#
.SYNOPSIS
    指定したファイルのSHA-256ハッシュを表示します。

.DESCRIPTION
    PowerShell標準の Get-FileHash を使って、
    指定されたファイルのSHA-256ハッシュ値を計算します。

    初心者向けサンプルとして、
    ・ファイルが存在するか
    ・指定されたパスがフォルダではないか
    も確認します。

.EXAMPLE
    .\Get-FileSha256.ps1 -Path "C:\Temp\sample.zip"

.EXAMPLE
    .\Get-FileSha256.ps1 -Path ".\sample.txt"
#>

param(
    # ハッシュ値を確認したいファイルのパス
    [Parameter(Mandatory = $true)]
    [string]$Path
)

# ------------------------------------------------------------
# 1. 指定されたパスが存在するか確認する
# ------------------------------------------------------------
# -LiteralPath を使うと、[ ] などの特殊文字を含むパスも
# そのままの文字列として扱えます。
if (-not (Test-Path -LiteralPath $Path)) {
    Write-Error "指定されたパスが見つかりません: $Path"
    exit 1
}

# ------------------------------------------------------------
# 2. 相対パスを絶対パスへ変換する
# ------------------------------------------------------------
# Resolve-Path で、実際のファイル位置を取得します。
$resolvedPath = (Resolve-Path -LiteralPath $Path).Path

# ------------------------------------------------------------
# 3. フォルダではなく、ファイルが指定されているか確認する
# ------------------------------------------------------------
$item = Get-Item -LiteralPath $resolvedPath

if ($item.PSIsContainer) {
    Write-Error "フォルダではなく、ファイルを指定してください: $resolvedPath"
    exit 1
}

# ------------------------------------------------------------
# 4. SHA-256ハッシュを計算する
# ------------------------------------------------------------
# Get-FileHash は PowerShell 標準コマンドです。
# -Algorithm SHA256 で SHA-256 を指定します。
$hashResult = Get-FileHash -LiteralPath $resolvedPath -Algorithm SHA256

# ------------------------------------------------------------
# 5. 結果を見やすい形で表示する
# ------------------------------------------------------------
# PSCustomObject にすると、項目名付きで結果を扱えます。
$result = [PSCustomObject]@{
    File      = $resolvedPath
    Algorithm = $hashResult.Algorithm
    Hash      = $hashResult.Hash
}

$result | Format-List
