param(
    [int]$Port = 8085
)

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$client = $null
$stream = $null
$reader = $null

try {
    # localhostだけで待ち受けます。
    # 外部NICへ公開しないため、学習用サーバーを誤ってLANへ公開しにくくします。
    $listener.Start()
    Write-Host "LISTEN 127.0.0.1:$Port"
    Write-Host "ここでクライアント接続を待ちます。"

    # AcceptTcpClient() は接続が来るまで待機する同期処理です。
    $client = $listener.AcceptTcpClient()
    Write-Host "ACCEPT $($client.Client.RemoteEndPoint)"

    $stream = $client.GetStream()

    # HTTP/1.1のrequest lineとheaderはUS-ASCII互換で読めます。
    # StreamReaderで1行ずつ読み、空行までをheader sectionとして扱います。
    $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)

    Write-Host "=== REQUEST ==="
    while ($true) {
        $line = $reader.ReadLine()
        if ($null -eq $line -or $line.Length -eq 0) { break }
        Write-Host $line
    }

    $body = "Hello from localhost HTTP over TCP`n"
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

    # Content-Lengthは文字数ではなく、送信するbodyのoctet数です。
    $header = @(
        "HTTP/1.1 200 OK"
        "Content-Type: text/plain; charset=utf-8"
        "Content-Length: $($bodyBytes.Length)"
        "Connection: close"
        ""
        ""
    ) -join "`r`n"

    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    $stream.Write($bodyBytes, 0, $bodyBytes.Length)
    $stream.Flush()

    Write-Host "=== RESPONSE ==="
    Write-Host "HTTP/1.1 200 OK"
    Write-Host "Content-Length: $($bodyBytes.Length)"
}
finally {
    # 途中でエラーになってもsocketを残さないよう、逆順に後始末します。
    if ($reader) { $reader.Dispose() }
    if ($stream) { $stream.Dispose() }
    if ($client) { $client.Close() }
    $listener.Stop()
    Write-Host "CLOSED"
}
