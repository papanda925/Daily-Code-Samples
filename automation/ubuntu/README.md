# Ubuntu → WordPress 自動連携

14:00の既存ブログ枠をDaily Code専用に置き換えるための連携コードです。

処理は次の順です。

1. GitHubから最新状態をpull
2. 未記事化のサンプルを1件検出
3. READMEとソースからブログ用Markdownを生成
4. new_gemini_postbot の gutenberg_serializer.py でWordPress向けに変換
5. WP-CLIでWordPressへ公開
6. post_id と permalink を確認
7. GitHubのトップREADMEとサンプルREADMEへ記事URLを書き戻し
8. git commit / push

## 二重投稿防止

状態は /home/papanda925/new_gemini_postbot/state/daily_code_wordpress.json に保存します。

WordPress公開後にGitHubへのpushだけ失敗した場合、次回はWordPressへ再投稿せず、GitHub書き戻しだけを再試行します。

## 初回導入

Ubuntuで以下を実行します。

    cd ~/Daily-Code-Samples
    git pull origin main
    chmod +x automation/ubuntu/*.sh
    ./automation/ubuntu/install.sh

install.sh は最初に dry-run を行い、その後systemdのdrop-inを設定します。

## systemd

既存の gemini_postbot_auto_post.timer はそのまま使用します。

14:00だけ dispatch_with_daily_code.sh がDaily Codeへ分岐し、それ以外の9枠は既存の tools/production_dispatcher.py を実行します。

## GitHub認証

WordPress公開後にREADMEへURLを書き戻すため、Ubuntuから次が成功する必要があります。

    cd ~/Daily-Code-Samples
    git pull origin main
    git push origin main

SSH remoteを推奨します。

    git@github.com:papanda925/Daily-Code-Samples.git

## ロールバック

14:00を従来動作へ戻す場合は以下を実行します。

    sudo rm /etc/systemd/system/gemini_postbot_auto_post.service.d/daily-code.conf
    sudo systemctl daemon-reload
    sudo systemctl restart gemini_postbot_auto_post.timer
