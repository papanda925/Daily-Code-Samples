param(
    [int]$Port = 8085
)

$client = [System.Net.Sockets.TcpClient]::new()
$stream = $null

try {
    Write-Host "CONNECT 127.0.0.1:$Port"
    $client.Connect("127.0.0.1", $Port)

    # TcpClient.GetStream()でTCP上の送受信用NetworkStreamを取得します。
    $stream = $client.GetStream()

    # HTTP/1.1ではstart-lineの後にheader fieldsを置き、
    # 空行(CRLF CRLF)でheader sectionを終えます。Host headerも送ります。
    $request = @(
        "GET / HTTP/1.1"
        "Host: localhost:$Port"
        "Connection: close"
        ""
        ""
    ) -join "`r`n"

    $requestBytes = [System.Text.Encoding]::ASCII.GetBytes($request)

    Write-Host "=== SEND ==="
    Write-Host $request

    $stream.Write($requestBytes, 0, $requestBytes.Length)
    $stream.Flush()

    # サーバーはConnection: closeで応答するため、
    # Read()が0 byteを返すまで読めばレスポンス全体を取得できます。
    $buffer = New-Object byte[] 4096
    $memory = [System.IO.MemoryStream]::new()

    try {
        while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $memory.Write($buffer, 0, $read)
        }

        $response = [System.Text.Encoding]::UTF8.GetString($memory.ToArray())
        Write-Host "=== RECEIVE ==="
        Write-Host $response
    }
    finally {
        $memory.Dispose()
    }
}
finally {
    if ($stream) { $stream.Dispose() }
    $client.Close()
    Write-Host "CLOSED"
}
