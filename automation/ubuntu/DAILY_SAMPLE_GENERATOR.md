# 1日1本の新規サンプル生成

`generate_daily_sample_once.py` は、#301以降を **1日1本だけ**追加するための公開版オーケストレーターです。

## 何が変わったか

300本体制を受け、単に「新しいコードを1本作る」だけではなく、次を自動生成の品質条件にしました。

1. 既存タイトルとの重複回避
2. Trackのローテーション
3. README + sample.json + 実コード
4. コード内の「なぜ」のコメント
5. テスト1 / テスト2
6. 実行前後の確認
7. 技術の層
8. 安全性
9. strict quality check
10. Public safety check
11. 成功時だけcommit / push

## 既定ではブログ記事化しない

新しく生成したsample.jsonには、

```json
{
  "maturity": "experimental",
  "article_ready": false
}
```

を設定します。

GitHub Pagesでは学習用サンプルとして見られますが、WordPress自動記事化はレビュー後に `article_ready=true` とする設計です。

## dry-run

```bash
python3 automation/ubuntu/generate_daily_sample_once.py --dry-run
```

ファイル変更やCodex実行は行わず、次のIDとTrackだけ確認します。

## 実行

```bash
CODEX_BIN=codex \
DAILY_CODE_REPO=/path/to/Daily-Code-Samples \
python3 automation/ubuntu/generate_daily_sample_once.py
```

本番の絶対パスや認証設定は、公開リポジトリではなくUbuntu側の非公開環境ファイルへ置きます。

## 同日二重生成防止

状態は既定で、

`~/.local/state/daily-code-generator/state.json`

に保存します。同じ日に複数回呼ばれても、通常は2本目を作りません。

## 失敗した場合

品質検査・Public safety・想定外ファイル変更のいずれかに失敗した場合、**自動commit / pushを行いません**。

人が確認できるよう作業ツリーに変更を残して停止します。
