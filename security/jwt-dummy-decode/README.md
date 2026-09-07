# 実トークンを使わずJWTの構造を観察する

完全なダミーデータだけで `header.payload.signature` の3部構造とBase64URL decodeを確認します。

## 安全方針

- 実際のMicrosoft Entra access tokenを入力しない
- 外部Webサイトへtokenを貼らない
- サンプルは `alg=none` の教育用未署名JWTで、認証には使えない
- decodeはsignature validationではない

Microsoftはaccess tokenを機密資格情報として扱い、クライアントアプリはopaque stringとして扱うよう案内しています。Microsoft API向けtokenが常にdecode可能なJWTとは限りません。

## 成功条件

`[RESULT] header` と `[RESULT] payload` が表示され、最後に `[SUCCESS]` が出れば構造観察成功です。

## 1か所変えてみる

ダミーpayloadの `role` を変えます。内容は簡単に変えられますが、それだけでは信頼できるtokenにはなりません。ここが「読める」と「正しい署名を持つ」の違いです。

## 検証状態

RFC 7519とMicrosoft identity platformの現行ドキュメントを確認して実装。このセッションではPowerShell実行未確認です。

## 公式情報

- RFC 7519 — JSON Web Token (JWT): https://www.rfc-editor.org/rfc/rfc7519.html
- Microsoft Learn — Access tokens: https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens
- Microsoft Learn — Access token claims reference: https://learn.microsoft.com/en-us/entra/identity-platform/access-token-claims-reference
