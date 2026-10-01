$path = Join-Path ([System.IO.Path]::GetTempPath()) 'papanda-fixed-record-demo.txt'

try {
    # 実在データではなく、固定幅を目で確認するための架空データを使います。
    $id = '0001'
    $name = 'ABC'
    $amount = '001250'

    # PadRightでname欄を8文字幅にします。
    # ここではASCIIだけなので文字数とUTF-8 byte数が一致します。
    $record = $id + $name.PadRight(8, ' ') + $amount

    # BOMなしUTF-8で1行を書きます。改行も観察できるよう環境改行を使います。
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $text = $record + [Environment]::NewLine
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)

    Write-Host "=== record ==="
    Write-Host "[$record]"

    Write-Host ""
    Write-Host "=== counts ==="
    [pscustomobject]@{
        Characters = $record.Length
        UTF8Bytes   = $utf8NoBom.GetByteCount($record)
        FileBytes   = (Get-Item $path).Length
    } | Format-List

    Write-Host "=== hex ==="
    Format-Hex -Path $path

    Write-Host ""
    Write-Host "[CHANGE] nameを '日本' に変え、Characters / UTF8Bytes / offsetの差を観察してください。"
}
finally {
    if (Test-Path $path) {
        Remove-Item $path -Force
        Write-Host "[CLEANUP] 一時ファイルを削除しました。"
    }
}
