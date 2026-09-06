$b=New-Object byte[] 2000;[Security.Cryptography.RandomNumberGenerator]::Fill($b);$b|Group-Object|Sort Name|Select Name,Count
