# Daily Code Samples

ブログ公開日や連番ではなく、**カテゴリから探せる実用コード・ツール集**です。

ネタの正本は `papanda925/Blog-Ideas/ideas`。ここには、記事で使う価値がある実装だけを置きます。

## カテゴリ

- `office/` — Office Scripts / Power Query M / Excel関数
- `windows/` — Win32 / WinRT / OS / GUI / デバイス
- `network/` — TCP/IP / HTTP / DNS / TLS / Socket
- `powershell/` — PowerShell実用コード
- `vba/` — VBA / Windows API / Office自動化の基礎
- `ubuntu/` — Bash / Linux / Nginx / PHP-FPM / systemd
- `security/` — マスク / Hash / 権限 / 安全確認
- `programming/` — 言語共通・アルゴリズム・データ形式
- `web/` — Browser API / JavaScript / Webライブラリの解説・サンプル
- `docs/` — GitHub Pagesで公開するサイトとライブデモ

各サンプルはカテゴリ配下に、用途が分かる短い名前で置きます。

例: `security/mask-config-secrets/`

変化の速い製品・サービス固有のテーマはカテゴリ化せず、必要な場合だけ関連する基礎カテゴリへ置きます。

旧構成は `legacy-archive` ブランチに保存しています。

## GitHub Pages / ライブデモ

GitHub Pages の公開物は **`docs/` に集約**します。
通常のコードサンプルと、ブラウザから直接実行する公開ページを分離するためです。

公開設定:

- Branch: `main`
- Folder: `/docs`

公開URL:

- トップ: `https://papanda925.github.io/Daily-Code-Samples/`
- ライブデモ: `https://papanda925.github.io/Daily-Code-Samples/demos/<demo-name>/`

ブラウザで実際に動かすデモは `docs/demos/` 配下へ追加します。
説明や学習用ドキュメントは必要に応じて `web/` 側に置き、公開デモへリンクします。

位置情報・カメラ・マイク等の権限を使うデモは、ユーザー操作後にだけ要求し、
取得した個人情報を保存・送信しない最小構成を基本とします。

最初の例: `docs/demos/geolocation-leaflet/`

## はじめて使う方へ

1. 興味のあるカテゴリのサンプルフォルダを開き、`README.md` の「何を体験するか」「まず試す」を読みます。
2. Webデモがある場合はREADME内の「ライブデモ」から開き、記載された操作と結果を比べます。
3. コードを理解したい場合は、READMEに示された実ファイル（通常 `docs/demos/<demo-name>/index.html` と `app.js`）を参照します。
4. うまく動かない場合は、READMEの「うまくいかないとき」と「検証」を確認してください。動作未確認の環境は未検証と記載しています。

### 動くWeb教材の例

- [SVGベジェ曲線をスライダーで動かす（解説README）](web/svg-bezier-control-lab/README.md)
- [Canvasの花火を操作する（解説README）](web/canvas-fireworks-accessible/README.md)
- [Web Audioの波形を観察する（解説README）](web/audio-waveform-lab/README.md)

**ブログとの関係**：papanda925.comの記事で考え方や最小例を紹介し、このリポジトリのREADME・実コードで操作と検証を詳しく説明します。READMEが空・見出しのみの場合は完成扱いせず、[SAMPLE_GUIDE.md](SAMPLE_GUIDE.md) の教材品質ゲートに従って個別修正します。GitHub Actionsは利用しません。
