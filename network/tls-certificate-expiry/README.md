# TLS証明書の有効期限をPowerShellで確認する

PowerShellから .NET の `TcpClient` と `SslStream` を使い、HTTPSサイトへTLS接続してサーバー証明書の有効期限を表示します。

## 実行例

```powershell
./Get-TlsCertificateExpiry.ps1 -HostName example.com
```

## ポイント

- 証明書検証を無効化するコールバックは使いません。
- TLS認証が失敗した場合はエラーにします。
- `NotAfter` から残り日数を計算します。

## 検証状態

Microsoft LearnのSslStream / X509Certificate2仕様を確認して実装。PowerShell実機確認は未実施です。

## まず試す前の条件

[Get-TlsCertificateExpiry.ps1](Get-TlsCertificateExpiry.ps1) は実ホストへTCP/TLS接続します。**外部通信が発生**するため、利用を許可された接続先に限定してください。PowerShell と .NET の `TcpClient` / `SslStream` が必要です。

```powershell
.\Get-TlsCertificateExpiry.ps1 -HostName example.com -Port 443
```

**期待結果（未実行）**：`Subject`、`Issuer`、`NotAfter`、`DaysRemaining`、`Thumbprint` が表示されます。値は接続時の証明書と時刻で変わるため固定値を断言しません。

## 失敗したとき・検証

DNS・接続・TLS証明書検証で失敗する場合があります。スクリプトは証明書検証を無効化しません。`finally` で接続を閉じます。2026-10-31：接続方法をソースで読取り確認。実ネットワーク通信は未実施。
