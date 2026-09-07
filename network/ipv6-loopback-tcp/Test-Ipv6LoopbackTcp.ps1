param(
    [ValidateRange(1024, 65535)]
    [int]$Port = 48061
)

$ErrorActionPreference = 'Stop'
$listener = $null
$client = $null
$serverClient = $null
$clientStream = $null
$serverStream = $null

Write-Host ("[START] IPv6 loopback [::1]:{0} だけでTCP通信を試します" -f $Port)

try {
    $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::IPv6Loopback, $Port)
    $listener.Server.DualMode = $false
    $listener.Start()
    Write-Host ("[LISTEN] {0}" -f $listener.LocalEndpoint)

    $acceptTask = $listener.AcceptTcpClientAsync()

    $client = [Net.Sockets.TcpClient]::new([Net.Sockets.AddressFamily]::InterNetworkV6)
    $client.Connect([Net.IPAddress]::IPv6Loopback, $Port)
    Write-Host ("[CONNECT] client={0} server={1}" -f $client.Client.LocalEndPoint, $client.Client.RemoteEndPoint)

    $serverClient = $acceptTask.GetAwaiter().GetResult()
    Write-Host ("[ACCEPT] remote={0}" -f $serverClient.Client.RemoteEndPoint)

    $clientStream = $client.GetStream()
    $serverStream = $serverClient.GetStream()

    $requestBytes = [Text.Encoding]::UTF8.GetBytes('HELLO_IPV6')
    $clientStream.Write($requestBytes, 0, $requestBytes.Length)
    Write-Host ("[SEND] bytes={0} text=HELLO_IPV6" -f $requestBytes.Length)

    $buffer = New-Object byte[] 64
    $read = $serverStream.Read($buffer, 0, $buffer.Length)
    $requestText = [Text.Encoding]::UTF8.GetString($buffer, 0, $read)
    Write-Host ("[SERVER RECV] bytes={0} text={1}" -f $read, $requestText)

    $replyBytes = [Text.Encoding]::UTF8.GetBytes('ACK_IPV6')
    $serverStream.Write($replyBytes, 0, $replyBytes.Length)

    $read = $clientStream.Read($buffer, 0, $buffer.Length)
    $replyText = [Text.Encoding]::UTF8.GetString($buffer, 0, $read)
    Write-Host ("[CLIENT RECV] bytes={0} text={1}" -f $read, $replyText)

    if ($requestText -ne 'HELLO_IPV6' -or $replyText -ne 'ACK_IPV6') {
        throw '送受信した文字列が期待値と一致しません。'
    }

    Write-Host '[SUCCESS] ::1 だけでIPv6 TCPの往復通信を確認しました'
    Write-Host '[TRY] DualMode=$true の意味を調べてから、IPv4-mapped addressとの関係を比較してください'
}
catch {
    Write-Error '[FAILED] IPv6 loopback TCPに失敗しました'
    Write-Error ("Type    : {0}" -f $_.Exception.GetType().FullName)
    Write-Error ("Message : {0}" -f $_.Exception.Message)
    exit 1
}
finally {
    if ($clientStream) { $clientStream.Dispose() }
    if ($serverStream) { $serverStream.Dispose() }
    if ($client) { $client.Dispose() }
    if ($serverClient) { $serverClient.Dispose() }
    if ($listener) { $listener.Stop() }
}
