# GitHub → Ubuntu → WordPress 自動連携サンプル

このフォルダは、**GitHubに追加した教材をUbuntuで検出し、WordPressへ記事化し、公開後のURLをGitHubへ書き戻す**構成例です。

公開リポジトリには、実サーバーのIPアドレス、ユーザー名、パスワード、APIキー、秘密鍵、本番ディレクトリ、実際のsystemd service名を保存しない設計にしています。

本番固有の値は、Ubuntu側だけに置く非公開の環境ファイルで設定します。

## 処理の流れ

1. GitHubから最新状態を `git pull`
2. 未記事化のサンプルを1件検出
3. READMEとソースからブログ用Markdownを生成
4. 既存ブログ環境のGutenberg serializerでWordPress向けに変換
5. WP-CLIでWordPressへ投稿
6. post ID と permalink を確認
7. GitHubのREADMEへ記事URLを書き戻し
8. `git commit / push`

## 公開版と本番環境の分離

公開するもの：

- 処理ロジック
- 二重投稿防止の考え方
- systemd連携例
- 環境変数の名前
- テスト・安全チェック

公開しないもの：

- 実サーバーのIPアドレス
- Linuxの実ユーザー名
- 本番WordPressの絶対パス
- 実際のsystemd service/timer名
- パスワード、token、APIキー
- SSH秘密鍵
- `.env` や本番用環境ファイル

## 既定では自動公開しない

公開サンプルの既定値は `DAILY_CODE_WP_STATUS=draft` です。

実際に自動公開する環境だけ、Ubuntu側の非公開設定で `publish` に変更します。

## 1. Ubuntu側に非公開の設定ファイルを作る

`daily-code.env.example` を参考に、本番サーバー上だけに設定を作ります。

```bash
sudo install -m 600 /dev/null /etc/daily-code-wordpress.env
sudoedit /etc/daily-code-wordpress.env
```

実際の値はGitへcommitしません。

## 2. GitHub認証を確認する

WordPress投稿後に記事URLを書き戻すため、Ubuntuから `git pull` と `git push` が成功する必要があります。

SSH鍵やtokenそのものはリポジトリへ保存しません。

## 3. dry-run

```bash
POSTBOT_ROOT=/path/to/blog-bot \
WP_PATH=/path/to/wordpress \
python3 automation/ubuntu/run_daily_code_once.py --dry-run
```

dry-runではWordPress投稿を行いません。

## 4. 既存systemdサービスへ組み込む場合

実際のservice名は公開ファイルへ書かず、実行時に渡します。

```bash
export POSTBOT_ROOT=/path/to/blog-bot
export WP_PATH=/path/to/wordpress
export TARGET_SERVICE=your-blog-publisher.service
export TARGET_TIMER=your-blog-publisher.timer

./automation/ubuntu/install.sh
```

`install.sh` は最初にdry-runを実施してから、既存serviceへdrop-inを追加します。

## 二重投稿防止

状態ファイルは既定で `~/.local/state/daily-code-wordpress/state.json` に保存します。

WordPressへの投稿に成功し、その後GitHubへのpushだけ失敗した場合は、次回に同じ記事を再投稿せず、GitHubへの書き戻しだけを再試行します。

## セキュリティ

このリポジトリでは `tools/check_public_safety.py` とGitHub Actionsを使い、次のような情報の混入を検査します。

- `.env`
- `wp-config.php`
- SSH / PEM秘密鍵
- password / token / API key / client secret らしき実値
- public IPを設定値として直接書いたもの

これは補助的な検査です。秘密情報をcommitしてしまった場合は、ファイルを削除するだけでなく、**該当する資格情報を必ず失効・再発行**してください。

## ロールバック

本番サーバーで作成されたdrop-inを削除し、systemdを再読み込みします。

```bash
sudo rm /etc/systemd/system/<service-name>.d/daily-code.conf
sudo systemctl daemon-reload
sudo systemctl restart <timer-name>
```

本番のservice名やtimer名は、この公開リポジトリには保存しません。
