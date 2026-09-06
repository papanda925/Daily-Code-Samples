param(
    [Parameter(Mandatory)]
    [ValidateSet("Protect", "Unprotect")]
    [string]$Mode,

    [Parameter(Mandatory)]
    [string]$Path
)

$scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser

if ($Mode -eq "Protect") {
    $secure = Read-Host "保護する文字列" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $bytes = $null

    try {
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        $bytes = [Text.Encoding]::UTF8.GetBytes($plain)

        $protected = [System.Security.Cryptography.ProtectedData]::Protect(
            $bytes,
            $null,
            $scope
        )

        [IO.File]::WriteAllBytes($Path, $protected)
        Write-Host "保存しました: $Path"
    }
    finally {
        if ($bytes) {
            [Array]::Clear($bytes, 0, $bytes.Length)
        }

        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    return
}

$protected = [IO.File]::ReadAllBytes($Path)
$bytes = [System.Security.Cryptography.ProtectedData]::Unprotect(
    $protected,
    $null,
    $scope
)

try {
    [Text.Encoding]::UTF8.GetString($bytes)
}
finally {
    [Array]::Clear($bytes, 0, $bytes.Length)
}
