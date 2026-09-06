param(
    [Parameter(Mandatory = $true)]
    [string]$Domain
)

Write-Host "=== Resolve-DnsName TXT ==="
Resolve-DnsName -Name $Domain -Type TXT

Write-Host "`n=== nslookup TXT ==="
nslookup -type=TXT $Domain
