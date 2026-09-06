# Daily Code Samples

ブログで使うコード・コマンド・Tipsの実装リポジトリです。

## 新方式

ネタの正本は `papanda925/Blog-Ideas/ideas`。

```text
Blog-Ideas/ideas
    ↓ 必要なものだけ
Daily-Code-Samples/samples-v2
    ↓ 実行・確認
Blog-Ideas/publish
    ↓
WordPress
```

- Blog-Ideasで「1記事 = 1つの疑問」を管理
- コード/Tipsが必要な場合だけDaily Codeを作る
- 記事本文には理解に必要な最小コードだけ載せる
- 完全版は記事末尾の「GitHubサンプル」から対象ファイルへリンク
- 実行証拠がないものを verified / copy-paste-ready にしない
- 公式情報・一次情報とGitHubサンプルは別枠
- 時刻ごとの固定トピックは設けない

## 14:00 Daily Code

14:00の処理は、Blog-Ideasから `daily_code_required: true` かつ未実装の候補を1件選びます。
カテゴリ固定ではなく、重複・優先度・記事化価値・検証可能性を見て選びます。

## samples-v2

新方式のサンプルは `samples-v2/` からゼロスタートします。

旧 `samples/`、`ROADMAP.md`、`SNIPPET_ROADMAP.md` は過去資産として残しますが、新規ネタの正本にはしません。

新方式では番号を先に増やすのではなく、Blog-Ideasのideaに必要な実装だけを作ります。
