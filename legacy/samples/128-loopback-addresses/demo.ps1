'127.0.0.1','localhost','::1'|%{"=== $_ ===";Test-Connection $_ -Count 1 -EA 0}
