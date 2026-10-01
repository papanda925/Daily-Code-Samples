param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Domain,

    # 任意。NS確認で得た権威DNSなど、比較したいDNSサーバーを指定します。
    [string]$Server
)

$ErrorActionPreference = 'Stop'

Write-Host "=== 1. NS: 権威DNSの手掛かり ==="
try {
    Resolve-DnsName -Name $Domain -Type NS |
        Select-Object Name, Type, NameHost
}
catch {
    Write-Warning "NSの取得に失敗: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "=== 2. TXT: 通常の再帰DNS ==="
try {
    Resolve-DnsName -Name $Domain -Type TXT |
        Select-Object Name, Type, Strings, TTL
}
catch {
    Write-Warning "通常のTXT取得に失敗: $($_.Exception.Message)"
}

if ($Server) {
    Write-Host ""
    Write-Host "=== 3. TXT: 指定DNSサーバー $Server ==="
    try {
        # -Serverだけを変え、同じ名前のTXT応答を比較します。
        Resolve-DnsName -Name $Domain -Type TXT -Server $Server |
            Select-Object Name, Type, Strings, TTL
    }
    catch {
        Write-Warning "指定DNSサーバーからのTXT取得に失敗: $($_.Exception.Message)"
    }
}
else {
    Write-Host ""
    Write-Host "[INFO] -Server を指定すると、同じTXT名を別DNSサーバーへ直接問い合わせて比較できます。"
}

Write-Host ""
Write-Host "[CHECK] 値だけでなく、問い合わせ先とTTLも分けて確認してください。"
