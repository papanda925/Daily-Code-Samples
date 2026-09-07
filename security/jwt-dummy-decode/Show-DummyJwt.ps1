$ErrorActionPreference = 'Stop'

function ConvertTo-Base64Url([string]$Text) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    return [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
}

function ConvertFrom-Base64Url([string]$Text) {
    $base64 = $Text.Replace('-', '+').Replace('_', '/')
    switch ($base64.Length % 4) {
        2 { $base64 += '==' }
        3 { $base64 += '=' }
        0 { }
        default { throw 'Base64URLの長さが不正です。' }
    }
    return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($base64))
}

Write-Host '[START] 実アクセストークンを使わず、完全ダミーのJWT風データを作ります'

$header = '{"alg":"none","typ":"JWT"}'
$payload = '{"sub":"demo-user","role":"reader","purpose":"papanda-learning-only"}'

# alg=none の教育用・未署名JWT。認証用途には絶対に使わない。
$token = "$(ConvertTo-Base64Url $header).$(ConvertTo-Base64Url $payload)."
Write-Host ("[DUMMY] {0}" -f $token)

$parts = $token.Split('.')
if ($parts.Count -ne 3) {
    Write-Error '[FAILED] 3つの部分へ分割できませんでした'
    exit 1
}

$decodedHeader = ConvertFrom-Base64Url $parts[0]
$decodedPayload = ConvertFrom-Base64Url $parts[1]

Write-Host ("[RESULT] header  = {0}" -f $decodedHeader)
Write-Host ("[RESULT] payload = {0}" -f $decodedPayload)
Write-Warning 'このデモは署名検証をしていません。読めることと、信頼できることは別です。'

if ($decodedPayload -match 'papanda-learning-only') {
    Write-Host '[SUCCESS] header.payload.signature の構造とBase64URL decodeを観察できました'
}
else {
    Write-Error '[FAILED] ダミーpayloadを復元できませんでした'
    exit 1
}

Write-Host '[TRY] payloadのroleをwriterへ変え、文字列が変化しても「署名による信頼」は増えないことを確認してください'
