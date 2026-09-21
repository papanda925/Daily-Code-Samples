# Resolve-DnsNameでCNAMEとAを見分ける

## まず試す

```powershell
$Name = 'www.microsoft.com'
try {
    Write-Host "[START] $Name を照会します"
    Resolve-DnsName -Name $Name -Type CNAME -ErrorAction Stop | Format-Table Name,Type,NameHost -AutoSize
    Resolve-DnsName -Name $Name -Type A -ErrorAction Stop | Format-Table Name,Type,IPAddress -AutoSize
    Write-Host '[SUCCESS] DNS応答を取得しました'
} catch {
    Write-Host '[FAILED]' $_.Exception.Message
}
```

## ここを見る

CNAMEは別名から正規名への参照、Aは名前からIPv4アドレスへの対応です。対象によってCNAMEが存在しないことも正常です。

## 1か所変える

`www.microsoft.com` を自分が管理していない別の公開ホスト名へ変え、応答の違いを観察します。

## 仕事で使うなら

DNS切替やCDN利用時の一次切り分けに使えます。DNS応答だけでWebサービス全体の正常性は証明できません。

検証状態: 実装済み・未実行。
