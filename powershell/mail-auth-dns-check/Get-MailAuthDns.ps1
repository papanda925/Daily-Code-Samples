[CmdletBinding()]
param(
    # 調べたいドメイン。
    # 例: example.com
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Domain,

    # DKIMも確認したい場合だけselectorを指定します。
    # Microsoft 365ではselector1 / selector2がよく使われますが、
    # 実際のselectorは利用環境の設定を確認してください。
    [string]$DkimSelector
)

$Domain = $Domain.Trim().TrimEnd(".")

function Show-TxtRecord {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Label
    )

    Write-Host ""
    Write-Host "=== $Label ==="
    Write-Host "Name: $Name"

    try {
        # Resolve-DnsNameはDNSを参照するだけで、DNS設定を書き換えません。
        $records = Resolve-DnsName -Name $Name -Type TXT -ErrorAction Stop

        $values = @(
            $records |
                ForEach-Object {
                    # 長いTXTは複数文字列へ分割されて返ることがあるため、
                    # 1レコード内のStringsを結合して読みやすくします。
                    if ($_.Strings) {
                        $_.Strings -join ""
                    }
                }
        )

        if ($values.Count -eq 0) {
            Write-Warning "TXT応答はありましたが、表示できるStringsがありませんでした。"
            return
        }

        foreach ($value in $values) {
            Write-Output $value
        }
    }
    catch {
        # 「存在しない」と「DNS問い合わせ自体の失敗」は
        # ここでは断定せず、元のエラーメッセージも残します。
        Write-Warning "TXTレコードを取得できませんでした: $($_.Exception.Message)"
    }
}

# SPF:
# SPFは通常、対象ドメイン自身のTXTに v=spf1... として公開されます。
# ただし、DMARCで実際に評価されるSPF identityはMAIL FROM等なので、
# この表示だけで1通のメールのDMARC pass/failを判定できるわけではありません。
Show-TxtRecord -Name $Domain -Label "Domain TXT / SPF候補"

# DMARC:
# DMARC policyは _dmarc.<domain> のTXTを確認します。
Show-TxtRecord -Name "_dmarc.$Domain" -Label "DMARC"

# DKIM:
# DKIMはselectorが必要なので、指定されたときだけ問い合わせます。
if (-not [string]::IsNullOrWhiteSpace($DkimSelector)) {
    $selector = $DkimSelector.Trim()
    Show-TxtRecord -Name "$selector._domainkey.$Domain" -Label "DKIM ($selector)"
}
else {
    Write-Host ""
    Write-Host "=== DKIM ==="
    Write-Host "selector未指定のためスキップしました。"
    Write-Host "例: .\Get-MailAuthDns.ps1 -Domain example.com -DkimSelector selector1"
}
