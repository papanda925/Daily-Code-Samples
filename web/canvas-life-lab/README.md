# Canvasライフゲーム：B3/S23を1世代ずつ観察

## ライブデモ

[Canvasライフゲームを開く（GitHub Pages到達・ブラウザ動作未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/canvas-life-lab/)

ブラウザ標準のCanvas 2DとJavaScriptだけで動く、16×16の有限盤です。外部ライブラリ、APIキー、位置情報、個人データ、通信は不要です。初期状態では自動再生しません。

## 3操作

1. 「1世代進める」を押す。
2. 横3マスが縦3マスになり、第1世代と表示されるか見る。
3. もう一度押し、横3マスへ戻るか比べる。

| パターン | 期待する変化 |
|---|---|
| 点滅 | 2世代で元に戻る |
| 四角 | 次世代でも変化しない |
| グライダー | 4世代で右下に1マス移動 |
| 空白 | 変化しない |

「初期パターン」から切替え、「最初から」で戻せます。マスのクリックまたは行列入力による切替えにも対応しています。自動再生は700ms間隔、ページ非表示時は停止します。OSの動きを減らす設定では手動ステップのみです。

## 仕組みと境界

生きたマスは周囲8マスのうち2または3個が生存なら残ります。空白マスはちょうど3個が生存なら誕生します。更新は全マスを同時に行い、計算結果を新しい盤へ入れます（B3/S23）。端の外は常に空白として扱い、無限平面とは異なります。

## ファイル

- `docs/demos/canvas-life-lab/index.html` — デモUI
- `docs/demos/canvas-life-lab/app.js` — 操作とCanvas描画
- `docs/demos/canvas-life-lab/logic.js` — 副作用のない世代計算（Nodeからも読込可能）
- `web/canvas-life-lab/tests/life.test.cjs` — Node標準テスト

ローカルでは `docs/demos/canvas-life-lab/index.html` を開いて試せる設計です。テストはリポジトリ直下で `node --test web/canvas-life-lab/tests/life.test.cjs`。今回の実行環境ではV8によるロジック5条件のみ確認し、Node・実ブラウザは未実行です。

## うまく動かないとき

「準備中」のままならConsoleと `logic.js` / `app.js` の相対パスを確認してください。盤が出ない場合はCanvas 2Dの対応状況を確認してください。端でグライダーが消えるのは盤の外側を空白とする仕様です。再生中のタブを非表示にすると停止します。

## 公式・専門資料

- [MDN CanvasRenderingContext2D](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)
- [MDN fillRect](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillRect)
- [LifeWiki：Conway's Game of Life](https://conwaylife.com/wiki/Conway%27s_Game_of_Life)
- [LifeWiki：B3/S23表記](https://conwaylife.com/wiki/Rulestring)

公開Pages到達、WordPress実表示、モバイル、印刷/PDF、実ブラウザでの動作は未確認です。
