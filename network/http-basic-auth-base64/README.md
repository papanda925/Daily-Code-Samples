# HTTP Basic Authorizationヘッダーの形を観察する

実在資格情報を使わず、ダミー文字列をBase64へ変換してBasic認証ヘッダーの形を観察します。通信は行いません。

## 実行

```powershell
./demo.ps1
```

Base64は暗号化ではなく、元の文字列へ戻せます。実サービスのID・パスワードをコードへ書かないでください。

[RFC 7617 — The Basic HTTP Authentication Scheme](https://www.rfc-editor.org/rfc/rfc7617.html)

検証状態: RFC確認済み。実通信は未実施。

## コードの流れと結果

[demo.ps1](demo.ps1) は `demo-user:demo-password` の文字列をUTF-8バイト列へ変換し、Base64化して `Authorization: Basic ...` の形を表示し、直後に元へ戻します。

```powershell
.\demo.ps1
```

**期待結果（未実行）**：`[RESULT] Authorization: Basic ...` と `[OBSERVE] decoded=demo-user:demo-password` が表示されます。

## 注意・失敗時の対処・検証

Base64は暗号化ではなく、デコードすると内容が見えます。実在するパスワードやAuthorizationヘッダーをGit・画面共有・ログへ載せないでください。PowerShellで実行できない場合はスクリプトの場所と実行ポリシーを確認します。2026-10-31：ダミー文字列を使うことと通信処理がないことをソースで確認。PowerShell実行は未実施。
