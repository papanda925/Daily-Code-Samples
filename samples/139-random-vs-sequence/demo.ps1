"Sequence:";1..10
"Crypto random bytes:";$b=New-Object byte[] 10;[Security.Cryptography.RandomNumberGenerator]::Fill($b);$b
