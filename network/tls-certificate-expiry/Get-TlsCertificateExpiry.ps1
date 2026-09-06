param(
    [Parameter(Mandatory)]
    [string]$HostName,

    [int]$Port = 443
)

$tcp = New-Object System.Net.Sockets.TcpClient
$ssl = $null

try {
    $tcp.Connect($HostName, $Port)

    $ssl = New-Object System.Net.Security.SslStream($tcp.GetStream(), $false)
    $ssl.AuthenticateAsClient($HostName)

    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($ssl.RemoteCertificate)
    $days = [math]::Floor(($cert.NotAfter.ToUniversalTime() - [DateTime]::UtcNow).TotalDays)

    [pscustomobject]@{
        HostName      = $HostName
        Subject       = $cert.Subject
        Issuer        = $cert.Issuer
        NotBefore     = $cert.NotBefore
        NotAfter      = $cert.NotAfter
        DaysRemaining = $days
        Thumbprint    = $cert.Thumbprint
    }
}
finally {
    if ($ssl) {
        $ssl.Dispose()
    }

    $tcp.Close()
}
