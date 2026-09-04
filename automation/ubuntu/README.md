# GitHub → Ubuntu → Daily Code / WordPress 自動連携

このフォルダーは、Daily Code Samples の公開自動処理例です。

300本体制に合わせ、現在は2つの処理を分けています。

## A. 1日1本、新しいサンプルを増やす

`generate_daily_sample_once.py`

#301以降を、1日1本ずつ追加します。

単にコードを生成するだけでなく、次を品質ゲートにしました。

1. 既存タイトルと重複しないテーマを選ぶ
2. Trackをローテーションする
3. README + sample.json + 実コードを作る
4. コードへ「何をするか」「なぜそうするか」のコメントを入れる
5. READMEにテスト1 / テスト2を書く
6. 実行前後の確認と技術の層を書く
7. `tools/validate_sample.py --strict` を通す
8. Public safety checkを通す
9. 成功したcommitだけmainへpushする

生成は一時git worktree内で行います。AI生成が途中で失敗しても、mainの作業ツリーへ未完成コードを残しません。

新規サンプルは、

```json
{
  "maturity": "experimental",
  "article_ready": false
}
```

から開始します。

つまり **GitHub Pagesでは学習用サンプルとして見えるが、レビュー前にWordPressへ自動記事化しない** 設計です。

詳しくは [DAILY_SAMPLE_GENERATOR.md](./DAILY_SAMPLE_GENERATOR.md) を参照してください。

## B. GitHubのサンプルをWordPressへ1日1本記事化する

`run_daily_code_once.py`

処理の流れ：

1. GitHubから最新状態を `git pull`
2. 未記事化かつ `article_ready != false` のサンプルを1件選ぶ
3. READMEとソースからブログ用Markdownを組み立てる
4. コードの重複掲載を避ける
5. 「読む → 動かす → 1つ変える → 差を見る」の学習順序を付ける
6. 既存Gutenberg serializerでWordPress向けへ変換
7. WP-CLIで投稿
8. post ID と permalink を確認
9. sample.jsonへ `article_url` を書き戻す
10. GitHubへcommit / push

Pagesの詳細画面は `article_url` が入るとブログ記事へのボタンも表示します。

## 既存ブログ処理との共存

`dispatch_with_daily_code.sh` は、既存のブログdispatcherを壊さないようにします。

- 指定時間：新規sample生成を実行してから通常dispatcherへ続行
- Daily Code枠：WordPress Daily Codeへ分岐
- その他：既存ブログdispatcherへ戻る

新規sample生成が失敗しても、通常ブログ処理は継続します。

## 公開版と本番環境の分離

公開するもの：

- 処理ロジック
- 品質ルール
- 二重実行防止
- systemd連携例
- 環境変数名
- テスト・安全チェック

公開しないもの：

- 実サーバーのIPアドレス
- Linuxの実ユーザー名
- 本番WordPressの絶対パス
- 実際のsystemd service/timer名
- 認証情報
- SSH秘密鍵
- 本番用env

## dry-run

WordPress側：

```bash
POSTBOT_ROOT=/path/to/blog-bot \
WP_PATH=/path/to/wordpress \
python3 automation/ubuntu/run_daily_code_once.py --dry-run
```

新規sample生成側：

```bash
python3 automation/ubuntu/generate_daily_sample_once.py --dry-run
```

## 1日1本生成を有効にする

公開例では誤動作防止のためOFFです。

本番Ubuntuの**非公開**環境ファイルで、Codex CLIとGit pushを確認した後に、

```text
DAILY_SAMPLE_GENERATOR_ENABLED=1
DAILY_SAMPLE_GENERATE_HOUR=6
CODEX_BIN=codex
```

のように有効化します。

既存タイマーが06:00にもdispatcherを呼ぶ構成なら、06:00に1本生成したあと、本来の06:00ブログ処理へ続きます。

## セキュリティ

`tools/check_public_safety.py` で、公開リポジトリへの資格情報・本番設定値の混入を検査します。

さらに新規sampleは `tools/validate_sample.py --strict` を通し、README不足・コメント不足・TODO残りも止めます。

## ロールバック

自動生成処理はGit commit単位です。問題のある1本だけ通常のGit revertで戻せます。

systemd連携のdrop-inを外す場合は、本番サーバー側で既存のdrop-inを削除し、daemon-reload後にタイマーを再起動します。
