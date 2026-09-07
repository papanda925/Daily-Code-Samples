# SPF / DMARC / DKIM のDNSレコードをPowerShellで確認する

自分のドメインで公開されているメール認証用DNS情報を、PowerShellの `Resolve-DnsName` で**読み取り専用**確認するサンプルです。

## すぐ試す

SPF候補とDMARCを確認:

```powershell
.\Get-MailAuthDns.ps1 -Domain example.com
```

DKIM selectorも分かっている場合:

```powershell
.\Get-MailAuthDns.ps1 -Domain example.com -DkimSelector selector1
```

`example.com` と `selector1` は、自分の確認対象へ置き換えてください。

## 何を見ているか

- SPF候補: `example.com` のTXT
- DMARC: `_dmarc.example.com` のTXT
- DKIM: `selector1._domainkey.example.com` のTXT

## 大事な注意

このスクリプトは**DNSに何が公開されているかを見るだけ**です。

次のことまでは判定しません。

- 実際のメールがSPF passしたか
- DKIM署名が暗号学的にvalidだったか
- SPF/DKIMのドメインがFromドメインとalignmentしたか
- 最終的にDMARC pass/failになったか

実メールの認証結果は、メッセージヘッダーのAuthentication-Results等と合わせて確認します。

SPFはMAIL FROM等のidentityが関係するため、画面に見えるFromドメインのTXTを読むだけで実メールのSPF結果を断定しないでください。

## 安全性

`Resolve-DnsName` による問い合わせだけで、DNSレコードを変更しません。

秘密情報を入力する必要もありません。公開DNSに存在する情報を参照します。

## 検証状態

Microsoftの `Resolve-DnsName` の一般的な利用形に沿って実装していますが、この作成環境にはWindows PowerShellの `Resolve-DnsName` 実行環境がないため、実行確認はしていません。
