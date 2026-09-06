param(
    # 接続先のホスト名です。
    # 証明書の名前検証にも使うため、IPアドレスより
    # 実際のDNS名を指定するのが基本です。
    [Parameter(Mandatory)]
    [string]$HostName,

    # HTTPSの標準ポートは443です。
    # 別ポートでTLSを待ち受けるサーバー向けに変更可能にしています。
    [int]$Port = 443
)

# TcpClient は「TCP接続」を担当する .NET クラスです。
# ここではまだTLSではなく、まず接続先ポートまでTCPでつなぎます。
$tcp = New-Object System.Net.Sockets.TcpClient

# 後で finally から安全にDisposeできるよう、
# 最初は $null で変数だけ用意しておきます。
$ssl = $null

try {
    # まず HostName:Port へTCP接続します。
    # DNS名前解決やTCP接続に失敗した場合は、ここで例外になります。
    $tcp.Connect($HostName, $Port)

    # SslStream は、既存のTCPストリームの上にTLSを重ねる .NET クラスです。
    #
    # 第2引数 $false は、
    # SslStreamを閉じたときに内側のストリームを開いたまま残さない、
    # という指定です。
    $ssl = New-Object System.Net.Security.SslStream($tcp.GetStream(), $false)

    # TLSクライアントとしてハンドシェイクを開始します。
    #
    # $HostName はSNIや証明書の名前検証に使われます。
    # 証明書検証を無効化していないため、
    # 無効な証明書ならここで例外になります。
    $ssl.AuthenticateAsClient($HostName)

    # RemoteCertificate は接続先が提示したサーバー証明書です。
    #
    # X509Certificate2 に包み直すことで、
    # Subject / Issuer / NotAfter / Thumbprint などを
    # PowerShellから扱いやすくします。
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($ssl.RemoteCertificate)

    # NotAfter は証明書の有効期限です。
    #
    # UTCへそろえて現在時刻との差を取り、
    # 小数点以下を切り捨てて「残り何日か」を出します。
    $days = [math]::Floor(
        ($cert.NotAfter.ToUniversalTime() - [DateTime]::UtcNow).TotalDays
    )

    # 結果を1つのオブジェクトにまとめます。
    # こうしておくと、Format-Tableだけでなく
    # Export-CsvやWhere-Objectなどへ後からつなげやすくなります。
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
    # TLS接続を確実に閉じます。
    #
    # try途中で失敗していて $ssl が作られていない場合もあるため、
    # $null ではないときだけ Dispose() します。
    if ($ssl) {
        $ssl.Dispose()
    }

    # TCP接続も最後に閉じます。
    # finally に置くことで、途中で例外が起きても後始末されます。
    $tcp.Close()
}
