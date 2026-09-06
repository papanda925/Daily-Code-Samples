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
