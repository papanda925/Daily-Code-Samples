#requires -Version 5.1
param(
    [Parameter(Mandatory=$true)][string]$HostsFile,
    [Parameter(Mandatory=$true)][string]$OutputCsv
)

$results = foreach ($target in Get-Content -LiteralPath $HostsFile) {
    $target = $target.Trim()
    if (-not $target) { continue }

    # 1回だけ疎通確認します。対象側の設定によってPingが拒否される場合があります。
    $ok = Test-Connection -ComputerName $target -Count 1 -Quiet -ErrorAction SilentlyContinue

    [pscustomobject]@{
        Target = $target
        Reachable = $ok
        CheckedAt = Get-Date
    }
}

$results | Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "結果を保存しました: $OutputCsv"
