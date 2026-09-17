# DNSのA/AAAAレコードを観察する

名前解決でIPv4とIPv6がどう返るかを、読み取り専用で確認します。

## まず試す

```powershell
Resolve-DnsName example.com -Type A
Resolve-DnsName example.com -Type AAAA
```

## ここを見る

`Type` と `IPAddress` を見比べます。AはIPv4、AAAAはIPv6です。

## 1か所変える

`example.com` を自分が管理・利用する公開ホスト名へ変えます。内部名や秘密情報を公開ログへ貼らないでください。

## 仕事で使うなら

「名前は引けるが接続できない」問題の最初の切り分け、IPv4/IPv6差の確認に使えます。

## 注意点

DNS応答があることは、HTTP/TLSやアプリケーションが正常という意味ではありません。

検証状態: implemented。実ネットワークでは未確認です。
