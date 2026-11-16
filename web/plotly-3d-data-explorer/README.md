# 3D曲面の高さを変えるWebGLグラフ — Plotly.js

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/plotly-3d-data-explorer/

**URL到達とブラウザー実操作は未検証。** GitHubの `main/docs` を静的配信に使う。配信確認ができない状態で「動作確認済み」と記載しない。

## なぜこの教材を作るのか

5×5の架空測定値を3D曲面に表示し、高さ倍率を1〜3倍へ動かします。マウスで回転・ズームして形状を観察できます。

## 操作と期待結果

倍率1では最大高さ16、倍率3では最大高さ48。面の高さは変わるが格子点の数は25のままです。

- デモのHTML/CSS/JSは `docs/demos/plotly-3d-data-explorer/`
- 純粋な計算・前提値は `logic.mjs` に分離
- ブラウザー用画面は `app.mjs`。第三者ライブラリは `vendor/plotly-gl3d.min.js` に静的同梱
- `web/plotly-3d-data-explorer/tests/logic.test.mjs` はNode標準テストランナー用
- `node --test web/plotly-3d-data-explorer/tests/logic.test.mjs` でロジックの期待結果を検査
- ローカルでは `python3 -m http.server 8000 -d docs` を実行し `http://localhost:8000/demos/plotly-3d-data-explorer/` にアクセス

## 実装の境界・注意

WebGLに対応するブラウザーとGPU環境が必要です。動きの軽減設定、モバイル性能、WebGL不可環境でのフォールバックは別途検証します。

外部CDNや課金APIを実行時に呼び出すようには設計していない。第三者ライブラリのJS/CSSは、下記の固定タグのファイルを直接同梱。ライブラリを自作したとは主張しない。

## ライブラリ・ライセンスの出典

- ライブラリ：Plotly.js 3.1.0
- 公式GitHub：https://github.com/plotly/plotly.js
- API：https://github.com/plotly/plotly.js / https://plotly.com/javascript/3d-surface-plots/
- ライセンス：MIT、全文は `docs/demos/plotly-3d-data-explorer/vendor/LICENSE.txt`
- vendorバイナリのGit blob SHA：`e1b9da3ebd4502c983829abbe09885784578571d`
- ライセンスのGit blob SHA：`13ffac3c942fd6f6e8af7d4e58860bb306db3e2f`
- 将来のバージョン更新は意図的なレビューと動作再検証を行い、勝手に最新版を読み込まない。

**今回未確認**：GitHub Pagesのブラウザーでの表示、モバイル、WordPress記事内埋込、スクリーンリーダー実機試験。外部通信・権限・ライセンスの説明は教材に限定する。
