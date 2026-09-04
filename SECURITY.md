# Security Policy

## Public repository policy

このリポジトリは公開教材です。

実運用環境の以下の情報はcommitしません。

- パスワード
- APIキー / access token / client secret
- SSH秘密鍵
- `.env`
- `wp-config.php`
- 実サーバーのIPアドレスを含む本番接続情報
- 本番固有のユーザー名、絶対パス、systemd service名

公開可能なコードでは、実環境の値を環境変数やローカル設定ファイルに分離します。

## Automated check

`tools/check_public_safety.py` をGitHub Actionsとローカルの両方で実行できます。

```bash
python3 tools/check_public_safety.py
```

## If a secret is committed

秘密情報を誤ってcommitした場合、Git履歴から削除するだけでは不十分です。

1. 該当するpassword / token / keyを直ちに失効する
2. 新しい資格情報を発行する
3. 本番環境の設定を更新する
4. 必要に応じてGit履歴から情報を除去する
5. 不審なアクセス履歴を確認する

秘密情報そのものを公開Issueへ貼り付けないでください。
