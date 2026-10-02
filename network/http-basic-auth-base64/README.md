# HTTP Basic Authorizationヘッダーの形を観察する

実在資格情報を使わず、ダミー文字列をBase64へ変換してBasic認証ヘッダーの形を観察します。通信は行いません。

## 実行

```powershell
./demo.ps1
```

Base64は暗号化ではなく、元の文字列へ戻せます。実サービスのID・パスワードをコードへ書かないでください。

[RFC 7617 — The Basic HTTP Authentication Scheme](https://www.rfc-editor.org/rfc/rfc7617.html)

検証状態: RFC確認済み。実通信は未実施。
