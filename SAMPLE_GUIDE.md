# Sample Guide

## 基本形

`<category>/<purpose-name>/`

例:

- `powershell/file-hash/`
- `vba/xmlhttp-async-get/`
- `ubuntu/nginx-config-check/`
- `security/mask-config-secrets/`

## 1サンプル = 1目的

各フォルダには原則として次を置きます。

- `README.md`
- 実コード / コマンド例
- 必要に応じてテスト
- 必要に応じて `sample.json`

READMEには、何ができるか、前提条件、実行方法、期待結果、注意点を短く書きます。

コード内コメントは「何をしているか」だけでなく「なぜそうするか」も説明します。

## ブログ制作時の成果物

`Blog-Ideas` 側で `daily_code_required: true` の記事を作る場合、このサンプルも同じ制作作業の成果物として追加します。

記事を `ready` にする前に、次を確認します。

- サンプルフォルダがGitHub上に存在する
- READMEと実装がある
- 記事本文は最小例に留め、完全版をこのリポジトリへ置く
- 記事末尾の `GitHubサンプル` が対象フォルダへ直接リンクする
- 実行した場合だけ `tested` / `verified` とする

## 分類

公開日・記事ID・連番では分類しません。

使用するカテゴリ:

- `windows/`
- `network/`
- `powershell/`
- `vba/`
- `ubuntu/`
- `security/`
- `programming/`

変化の速い製品・サービス名は独立カテゴリにせず、内容に合う基礎カテゴリへ置きます。
