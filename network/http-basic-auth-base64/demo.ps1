$credentialText = 'demo-user:demo-password'
$bytes = [Text.Encoding]::UTF8.GetBytes($credentialText)
$encoded = [Convert]::ToBase64String($bytes)

Write-Host "[START] ダミー資格情報をBase64へ変換"
Write-Host "[RESULT] Authorization: Basic $encoded"

$decoded = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encoded))
Write-Host "[OBSERVE] decoded=$decoded"
Write-Host "[SUCCESS] 外部通信なしで往復を確認"
