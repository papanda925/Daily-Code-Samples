# CSVの引用符と重複ヘッダーをブラウザーで確かめる — Papa Parse

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/papaparse-csv-collisions/

**URL到達とブラウザー実操作は未検証。** GitHubの `main/docs` を静的配信に使う。配信確認ができない状態で「動作確認済み」と記載しない。

## なぜこの教材を作るのか

引用符で囲んだ「東京,本社」を1つのセルとして扱い、同じnameという見出しの重複を警告します。実ファイルはアップロードしません。

## 操作と期待結果

初期CSVは見出し3列・データ2行です。カンマを含む「東京,本社」は1つのセルです。見出しnameが2回登場するため警告します。

- デモのHTML/CSS/JSは `docs/demos/papaparse-csv-collisions/`
- 純粋な計算・前提値は `logic.mjs` に分離
- ブラウザー用画面は `app.mjs`。第三者ライブラリは `vendor/papaparse.min.js` に静的同梱
- `web/papaparse-csv-collisions/tests/logic.test.mjs` はNode標準テストランナー用
- `node --test web/papaparse-csv-collisions/tests/logic.test.mjs` でロジックの期待結果を検査
- ローカルでは `python3 -m http.server 8000 -d docs` を実行し `http://localhost:8000/demos/papaparse-csv-collisions/` にアクセス

## 実装の境界・注意

CSVの表示はtextContentを使用し、入力したHTMLを実行しません。日本語・引用符・重複ヘッダーの解析は実業務の全仕様を保証しません。

外部CDNや課金APIを実行時に呼び出すようには設計していない。第三者ライブラリのJS/CSSは、下記の固定タグのファイルを直接同梱。ライブラリを自作したとは主張しない。

## ライブラリ・ライセンスの出典

- ライブラリ：Papa Parse 5.5.3
- 公式GitHub：https://github.com/mholt/PapaParse
- API：https://github.com/mholt/PapaParse / https://www.papaparse.com/docs
- ライセンス：MIT、全文は `docs/demos/papaparse-csv-collisions/vendor/LICENSE.txt`
- vendorバイナリのGit blob SHA：`f31411042b80599f9dd6126ff8fd41f8fa8f68fb`
- ライセンスのGit blob SHA：`12f5b3503d99c72a03b654ac1b7ac51d6c408a05`
- 将来のバージョン更新は意図的なレビューと動作再検証を行い、勝手に最新版を読み込まない。

**今回未確認**：GitHub Pagesのブラウザーでの表示、モバイル、WordPress記事内埋込、スクリーンリーダー実機試験。外部通信・権限・ライセンスの説明は教材に限定する。
