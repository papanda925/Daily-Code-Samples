param(
    [ValidateNotNullOrEmpty()]
    [string]$Target = '127.0.0.1',

    [ValidateRange(1, 10)]
    [int]$Count = 3,

    [ValidateRange(100, 10000)]
    [int]$TimeoutMs = 1000
)

$ping = [System.Net.NetworkInformation.Ping]::new()

try {
    1..$Count | ForEach-Object {
        $n = $_

        try {
            # Ping.Send() はICMP Echo要求を送り、応答情報を返します。
            $reply = $ping.Send($Target, $TimeoutMs)

            [pscustomobject]@{
                Attempt         = $n
                Target          = $Target
                Status          = [string]$reply.Status
                Address         = if ($reply.Address) { [string]$reply.Address } else { $null }
                RoundtripTimeMs = if ($reply.Status -eq 'Success') { $reply.RoundtripTime } else { $null }
                BufferBytes     = if ($reply.Buffer) { $reply.Buffer.Length } else { 0 }
            }
        }
        catch {
            [pscustomobject]@{
                Attempt         = $n
                Target          = $Target
                Status          = 'Exception'
                Address         = $null
                RoundtripTimeMs = $null
                BufferBytes     = 0
                Error           = $_.Exception.Message
            }
        }
    }
}
finally {
    # IDisposableを明示的に解放します。
    $ping.Dispose()
}
