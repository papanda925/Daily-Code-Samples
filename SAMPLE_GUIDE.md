# Sample Guide

## 基本形

`<category>/<purpose-name>/`

例:

- `powershell/file-hash/`
- `vba/xmlhttp-async-get/`
- `ubuntu/nginx-config-check/`
- `security/mask-config-secrets/`
- `web/geolocation-leaflet/`

## 1サンプル = 1目的

各フォルダには原則として次を置きます。

- `README.md`
- 実コード / コマンド例
- 必要に応じてテスト
- 必要に応じて `sample.json`

READMEには、何ができるか、前提条件、実行方法、期待結果、注意点を短く書きます。

コード内コメントは**初心者向けに多め**を標準とします。「何をしているか」だけでなく「なぜそうするか」「このAPIや引数は何者か」「この行を省くと何が困るか」まで、必要に応じて説明します。

特に次はコメントを省略しません。

- .NET / COM / WinRT / Office Scripts / M言語 / Windows APIなど、初見で意味を推測しにくいAPI
- 定数、フラグ、列挙値、正規表現、特殊な型指定
- try/finally、Dispose、Closeなどの後始末
- エラー処理、安全確認、破壊的操作の前後
- 非同期処理、イベント、コールバック、パイプなど処理順が見えにくい部分
- 文字コード、暗号、ネットワークなど「動くが理由が分かりにくい」処理

コメントが増えてコードが長くなっても、学習価値が上がるなら許容します。
一方で「変数へ代入する」など、コードをそのまま日本語へ直訳するだけのコメントは避けます。

## ブログ制作時の成果物

`Blog-Ideas` 側で `daily_code_required: true` の記事を作る場合、このサンプルも同じ制作作業の成果物として追加します。

記事を `ready` にする前に、次を確認します。

- サンプルフォルダがGitHub上に存在する
- READMEと実装がある
- 記事本文は最小例に留め、完全版をこのリポジトリへ置く
- 記事末尾の `GitHubサンプル` が対象フォルダへ直接リンクする
- 実行した場合だけ `tested` / `verified` とする

## Web公開・ライブデモ

ブラウザでそのまま動かせるHTML / CSS / JavaScriptやBrowser APIの教材は、**解説・教材の場所**と**Web公開の場所**を分けます。

- 解説・教材: `web/<purpose-name>/README.md`
- 公開デモ: `docs/demos/<purpose-name>/index.html`
- 公開URL: `https://papanda925.github.io/Daily-Code-Samples/demos/<purpose-name>/`

Web公開できるサンプルのREADMEには、冒頭付近へ必ず `## ライブデモ` を置き、クリック可能な公開URLを載せます。

これによりブログ記事は従来どおり `GitHubサンプル` として教材READMEへリンクでき、読者はREADMEから実際に動くWebデモへ移動できます。

アプリとして独立性が高いものは `docs/apps/<app-name>/` を使用してよいです。

## 分類

公開日・記事ID・連番では分類しません。

使用するカテゴリ:

- `office/`
- `windows/`
- `network/`
- `powershell/`
- `vba/`
- `ubuntu/`
- `security/`
- `programming/`
- `web/`

`docs/` はカテゴリではなくGitHub Pagesの公開専用領域です。

変化の速い製品・サービス名は独立カテゴリにせず、内容に合う基礎カテゴリへ置きます。
