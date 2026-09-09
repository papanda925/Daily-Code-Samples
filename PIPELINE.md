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
- GitHub Actions の必須チェックが成功している
- ブログ末尾の `GitHubサンプル` が対象フォルダへ直接リンクしている

## GitHub品質ゲート

生成したコードは、GitHubへ追加しただけでは `ready` にしません。

PRまたはmainへの反映時に、次のGitHub Actionsを必ず実行します。

- `Public safety check`: 秘密情報・公開不適切情報の混入確認
- `Daily Code quality checks`: Python / JavaScript / Bash / PowerShell / JSON の構文・パース確認
- `CodeQL`: Python / JavaScript・TypeScript / GitHub Actions のセキュリティ静的解析

いずれかが失敗した場合は、そのサンプルを記事公開用の完成品として扱いません。

CodeQLが直接対応しないVBA、PowerShell、Bash、M言語、Excel数式等については、可能な範囲の構文チェックに加え、実機または対象アプリでの実行確認結果をREADMEへ記録します。

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
