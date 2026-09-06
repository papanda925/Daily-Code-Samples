# Blog-Ideas -> Daily-Code-Samples

`Blog-Ideas/ideas` がネタの正本です。

記事候補にコード・ツール・コマンド・Tipsが必要な場合、このリポジトリの該当カテゴリへ**記事制作の成果物として**実装します。

`idea -> category/sample -> verification -> article -> ready`

## 日次ブログ制作との関係

Daily-Code-Samplesは独立した14:00生成処理ではありません。

日次の記事制作で `daily_code_required: true` になった記事について、その記事を `ready` にする前に対応サンプルを追加します。

記事制作の完了条件:

- `<category>/<purpose-name>/` が存在する
- `README.md` がある
- 実コードまたは再利用できるコマンド例がある
- 必要に応じてテストがある
- 実行有無と検証状態が正しく記録されている
- ブログ末尾の `GitHubサンプル` が対象フォルダへ直接リンクしている

## 分類

日付・公開順・固定時刻・連番では分類しません。

長く使えるカテゴリだけを使います。

- `windows/`
- `network/`
- `powershell/`
- `vba/`
- `ubuntu/`
- `security/`
- `programming/`

カテゴリ + 用途名で探せるパスにします。

例:

- `security/mask-config-secrets/`
- `ubuntu/nginx-config-check/`
- `vba/xmlhttp-async-get/`

## 記事との役割分担

- 記事本文: 理解に必要な最小コード
- Daily-Code-Samples: 完全版・再利用版・コメント付き実装

同じ長いコードを記事本文とGitHubへ二重掲載しません。

## 検証

実行証拠がないものを `tested` / `verified` / `copy_paste_ready` にしません。

未実行でもサンプルを置くことはできますが、その場合は未検証であることを明示します。
