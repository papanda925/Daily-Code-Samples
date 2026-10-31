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
- GitHub Actionsを使用せず、可能なローカル検査・README教材品質確認の結果が記録されている
- ブログ末尾の `GitHubサンプル` が対象フォルダへ直接リンクしている

## GitHub品質ゲート（Actionsなし）

GitHub Actions・有料Runnerは利用しません。記事制作を担当するChatGPTが、同じ制作作業でREADME・実コード・記事末尾リンクを突き合わせ、P1〜P5自己審査を実施します。実行できる環境がある場合のみ、Python/JavaScript/Bash/PowerShell/JSON等の構文・テストをローカルで実施します。

確認項目は次のとおりです。

- READMEが見出しだけの空教材になっておらず、目的、具体的操作、期待結果、しくみ、変更実験、失敗時対処、安全、検証状況、公式資料を説明している。
- READMEのファイル名・ボタン名・デモURLが実装と一致する。デモ未到達時は公開確認済みと書かない。
- 秘密情報や実環境の内部情報を含まず、権限や外部通信の有無を説明する。
- 実行結果・ローカル構文確認・未検証を区別し、未実行をPASSと記録しない。
- ブログは簡潔な導入と最小例、GitHubは完全版・README教材と役割分担する。

詳しいREADME品質基準は [SAMPLE_GUIDE.md](SAMPLE_GUIDE.md) を参照してください。既存の自動チェック用ファイルが残っていても、Actionsを実行する指示とはみなしません。

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
