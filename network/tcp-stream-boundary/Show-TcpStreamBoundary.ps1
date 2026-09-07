param(
    [ValidateRange(1024, 65535)]
    [int]$Port = 48062
)

$ErrorActionPreference = 'Stop'
$listener = $null
$client = $null
$serverClient = $null
$clientStream = $null
$serverStream = $null

Write-Host '[START] Send回数とReceive回数を比べます'

try {
    $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $Port)
    $listener.Start()
    $acceptTask = $listener.AcceptTcpClientAsync()

    $client = [Net.Sockets.TcpClient]::new()
    $client.Connect([Net.IPAddress]::Loopback, $Port)
    $serverClient = $acceptTask.GetAwaiter().GetResult()

    $clientStream = $client.GetStream()
    $serverStream = $serverClient.GetStream()

    # アプリ側では2回に分けて送る。
    foreach ($part in @('ABC', 'DEFG')) {
        $bytes = [Text.Encoding]::ASCII.GetBytes($part)
        $clientStream.Write($bytes, 0, $bytes.Length)
        Write-Host ("[SEND] bytes={0} text={1}" -f $bytes.Length, $part)
    }

    # 受信側は意図的に2バイトの小さなバッファを使う。
    # 7バイト全部を読むには、最低でも4回のReadが必要になる。
    $buffer = New-Object byte[] 2
    $received = [Text.StringBuilder]::new()
    $readCount = 0

    while ($received.Length -lt 7) {
        $read = $serverStream.Read($buffer, 0, $buffer.Length)
        if ($read -eq 0) {
            throw '7バイト受信する前に接続が閉じられました。'
        }

        $readCount++
        $text = [Text.Encoding]::ASCII.GetString($buffer, 0, $read)
        [void]$received.Append($text)
        Write-Host ("[RECV #{0}] bytes={1} text={2}" -f $readCount, $read, $text)
    }

    Write-Host '[RESULT] Application Send calls = 2'
    Write-Host ("[RESULT] Server Read calls      = {0}" -f $readCount)
    Write-Host ("[RESULT] Reassembled text       = {0}" -f $received.ToString())

    if ($received.ToString() -ne 'ABCDEFG' -or $readCount -le 2) {
        throw '期待した再構成結果またはRead回数になりませんでした。'
    }

    Write-Host '[SUCCESS] Sendの呼び出し回数とReadの呼び出し回数が1対1ではないことを観察しました'
    Write-Host '[TRY] 受信バッファを4バイトへ変え、Read回数がどう変わるか予想してから再実行してください'
}
catch {
    Write-Error '[FAILED] TCP stream boundary demo に失敗しました'
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
