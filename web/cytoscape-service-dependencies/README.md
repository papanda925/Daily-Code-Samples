# 障害が波及する依存関係をクリックで追う — Cytoscape.js

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/cytoscape-service-dependencies/

**URL到達とブラウザー実操作は未検証。** GitHubの `main/docs` を静的配信に使う。配信確認ができない状態で「動作確認済み」と記載しない。

## なぜこの教材を作るのか

架空の4サービスと依存矢印を表示します。DBに障害が起きたと仮定すると、DBに依存するAPIとポータルまで影響候補に現れます。

## 操作と期待結果

DBを選ぶと影響候補はAPIとポータル。認証を選ぶとポータル。実障害の検出ではなく依存辺を逆向きにたどる練習です。

- デモのHTML/CSS/JSは `docs/demos/cytoscape-service-dependencies/`
- 純粋な計算・前提値は `logic.mjs` に分離
- ブラウザー用画面は `app.mjs`。第三者ライブラリは `vendor/cytoscape.min.js` に静的同梱
- `web/cytoscape-service-dependencies/tests/logic.test.mjs` はNode標準テストランナー用
- `node --test web/cytoscape-service-dependencies/tests/logic.test.mjs` でロジックの期待結果を検査
- ローカルでは `python3 -m http.server 8000 -d docs` を実行し `http://localhost:8000/demos/cytoscape-service-dependencies/` にアクセス

## 実装の境界・注意

依存関係は手で与えた架空のデータ。実際の停止影響や技術的な重大度を自動判定できるものではありません。

外部CDNや課金APIを実行時に呼び出すようには設計していない。第三者ライブラリのJS/CSSは、下記の固定タグのファイルを直接同梱。ライブラリを自作したとは主張しない。

## ライブラリ・ライセンスの出典

- ライブラリ：Cytoscape.js 3.30.4
- 公式GitHub：https://github.com/cytoscape/cytoscape.js
- API：https://github.com/cytoscape/cytoscape.js / https://js.cytoscape.org/#core
- ライセンス：MIT、全文は `docs/demos/cytoscape-service-dependencies/vendor/LICENSE.txt`
- vendorバイナリのGit blob SHA：`f36c15d00f5e2589b531b501ed8783ebf06ad15d`
- ライセンスのGit blob SHA：`22fcccd7b6699b0d202f678cd6d846b0edd5ca8a`
- 将来のバージョン更新は意図的なレビューと動作再検証を行い、勝手に最新版を読み込まない。

**今回未確認**：GitHub Pagesのブラウザーでの表示、モバイル、WordPress記事内埋込、スクリーンリーダー実機試験。外部通信・権限・ライセンスの説明は教材に限定する。
