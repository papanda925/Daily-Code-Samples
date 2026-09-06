$texts = @(
    'ABC',
    '日本',
    'A日本',
    '😀'
)

$utf8 = [System.Text.Encoding]::UTF8

foreach ($text in $texts) {
    [pscustomobject]@{
        Text       = $text
        StringSize = $text.Length
        UTF8Bytes  = $utf8.GetByteCount($text)
    }
}

# --- 次の確認 ---

try {
    $sjis = [System.Text.Encoding]::GetEncoding(932)
}
catch {
    [System.Text.Encoding]::RegisterProvider(
        [System.Text.CodePagesEncodingProvider]::Instance
    )
    $sjis = [System.Text.Encoding]::GetEncoding(932)
}

$utf8 = [System.Text.Encoding]::UTF8

foreach ($text in @('ABC', '日本', 'A日本')) {
    [pscustomobject]@{
        Text       = $text
        UTF8Bytes  = $utf8.GetByteCount($text)
        SJISBytes  = $sjis.GetByteCount($text)
    }
}
