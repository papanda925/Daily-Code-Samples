#requires -Version 5.1

<#
.SYNOPSIS
    Sample 001 の動作を自動で確認します。

.DESCRIPTION
    一時フォルダにテスト用ファイルを作り、次の3点を確認します。

    1. コピーしたファイルは同じHashになる
    2. 中身を1文字変えるとHashが変わる
    3. ファイル名だけ変えてもHashは変わらない

    テスト終了後、一時ファイルは削除します。
#>

$ErrorActionPreference = 'Stop'
$tempDir = Join-Path $env:TEMP ("DailyCode001-" + [guid]::NewGuid().ToString("N"))

function Show-TestResult {
    param(
        [string]$Name,
        [bool]$Passed
    )

    if ($Passed) {
        Write-Host "[OK] $Name" -ForegroundColor Green
    }
    else {
        Write-Host "[NG] $Name" -ForegroundColor Red
        throw "テストに失敗しました: $Name"
    }
}

try {
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    $original = Join-Path $tempDir 'sample.txt'
    $copy     = Join-Path $tempDir 'sample-copy.txt'
    $renamed  = Join-Path $tempDir 'renamed.txt'

    # UTF-8で同じ内容のファイルを用意します。
    Set-Content -LiteralPath $original -Value 'こんにちは' -Encoding UTF8
    Copy-Item -LiteralPath $original -Destination $copy

    $hashOriginal = (Get-FileHash -LiteralPath $original -Algorithm SHA256).Hash
    $hashCopy = (Get-FileHash -LiteralPath $copy -Algorithm SHA256).Hash

    Show-TestResult 'コピーしたファイルは同じHashになる' ($hashOriginal -eq $hashCopy)

    # コピー側だけ中身を変更します。
    Set-Content -LiteralPath $copy -Value 'こんにちは!' -Encoding UTF8
    $hashChanged = (Get-FileHash -LiteralPath $copy -Algorithm SHA256).Hash

    Show-TestResult '中身を1文字変えるとHashが変わる' ($hashOriginal -ne $hashChanged)

    # 元ファイルは中身を変えず、名前だけ変更します。
    Move-Item -LiteralPath $original -Destination $renamed
    $hashRenamed = (Get-FileHash -LiteralPath $renamed -Algorithm SHA256).Hash

    Show-TestResult 'ファイル名だけ変えてもHashは変わらない' ($hashOriginal -eq $hashRenamed)

    Write-Host ""
    Write-Host "Sample 001 のテストはすべて成功しました。" -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $tempDir) {
        Remove-Item -LiteralPath $tempDir -Recurse -Force
    }
}
