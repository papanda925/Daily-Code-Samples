# CPU使用率のグラフと警告しきい値を動かす — Apache ECharts

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/echarts-service-load/

**URL到達とブラウザー実操作は未検証。** GitHubの `main/docs` を静的配信に使う。配信確認ができない状態で「動作確認済み」と記載しない。

## なぜこの教材を作るのか

7日間の架空CPU使用率を線グラフで示します。スライダーで警告しきい値を動かすと、警告日数と目標線が変わります。

## 操作と期待結果

しきい値75%なら2日、90%なら1日。クリックするデータがなくても数値で変化を確認できます。

- デモのHTML/CSS/JSは `docs/demos/echarts-service-load/`
- 純粋な計算・前提値は `logic.mjs` に分離
- ブラウザー用画面は `app.mjs`。第三者ライブラリは `vendor/echarts.simple.min.js` に静的同梱
- `web/echarts-service-load/tests/logic.test.mjs` はNode標準テストランナー用
- `node --test web/echarts-service-load/tests/logic.test.mjs` でロジックの期待結果を検査
- ローカルでは `python3 -m http.server 8000 -d docs` を実行し `http://localhost:8000/demos/echarts-service-load/` にアクセス

## 実装の境界・注意

ライブラリはApache 2.0。線グラフの数値を変える実験であり、実サーバー監視ではありません。しきい値は運用SLAとは無関係です。

外部CDNや課金APIを実行時に呼び出すようには設計していない。第三者ライブラリのJS/CSSは、下記の固定タグのファイルを直接同梱。ライブラリを自作したとは主張しない。

## ライブラリ・ライセンスの出典

- ライブラリ：Apache ECharts 5.6.0
- 公式GitHub：https://github.com/apache/echarts
- API：https://github.com/apache/echarts / https://echarts.apache.org/en/option.html#series-line
- ライセンス：Apache-2.0、全文は `docs/demos/echarts-service-load/vendor/LICENSE.txt`
- vendorバイナリのGit blob SHA：`47cff0cf23a1ae9d83b0d3ab205d9993a0f47b28`
- ライセンスのGit blob SHA：`c633765305b658c2b42837d2b72071d73c0379c5`
- 将来のバージョン更新は意図的なレビューと動作再検証を行い、勝手に最新版を読み込まない。

**今回未確認**：GitHub Pagesのブラウザーでの表示、モバイル、WordPress記事内埋込、スクリーンリーダー実機試験。外部通信・権限・ライセンスの説明は教材に限定する。
