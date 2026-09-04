$inputText = Read-Host "Hash化する学習用文字列を入力"
1..3 | ForEach-Object {
    $salt = New-Object byte[] 16
    [Security.Cryptography.RandomNumberGenerator]::Fill($salt)

    $kdf = [Security.Cryptography.Rfc2898DeriveBytes]::new(
        $inputText,
        $salt,
        10000,
        [Security.Cryptography.HashAlgorithmName]::SHA256
    )
    try {
        [pscustomobject]@{
            Salt = [Convert]::ToHexString($salt)
            Hash = [Convert]::ToHexString($kdf.GetBytes(32))
        }
    }
    finally {
        $kdf.Dispose()
    }
}
