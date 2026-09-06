$b=New-Object byte[] 30;[Security.Cryptography.RandomNumberGenerator]::Fill($b);$s=[Convert]::ToBase64String($b);[pscustomobject]@{OriginalBytes=$b.Length;Base64Characters=$s.Length;Base64=$s}
