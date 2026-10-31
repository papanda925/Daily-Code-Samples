# Canvasのピクセル加工実験：明るさ・白黒とRGBの変化

外部画像なし・外部ライブラリなしの8×8架空色見本をCanvasで作り、`ImageData`を加工します。APIキー、ログイン、個人写真、位置情報は使いません。

## まず試す

[ライブデモ（公開URLの到達・実ブラウザ動作は未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/canvas-pixel-lab/)

1. 明るさスライダーを0から+60へ動かします。
2. 右の色見本と「中央のRGB」を左の元画像と比べます。
3. 白黒にチェックを入れ、RGBの3成分が同じ値になるか観察します。

| 操作 | 期待する結果 |
|---|---|
| 初期値0・白黒OFF | 左右のRGBが一致 |
| +60 | 右のRGB各成分が60増える。ただし最大255で止まる |
| 白黒ON・明るさ0 | 右のRGB3成分が同じ値 |
| 初期値に戻す | 0・白黒OFFへ復帰 |

期待値は仕様とロジックに基づくもので、一般端末での表示は未確認です。

## ファイル

- `docs/demos/canvas-pixel-lab/index.html` — デモUIとCanvas
- `docs/demos/canvas-pixel-lab/app.js` — 画像生成・変換・表示
- `web/canvas-pixel-lab/tests/pixels.test.js` — Node標準テスト

同じフォルダへHTMLとJSを保存し、`index.html`をブラウザで開く設計です。外部通信は不要です。テストはリポジトリのルートから `node --test web/canvas-pixel-lab/tests/pixels.test.js` を実行します。

## なぜ毎回元画像から加工するのか

スライダー操作のたびに加工済み画像へ+60を加えると、色がどんどん白へ寄り、0へ戻しても元に戻りません。初回に`getImageData()`で取得した元データを保持し、毎回そのコピーを加工して`putImageData()`で表示します。

RGBは各0〜255、Aは透明度です。この教材はRGBだけを変更し、Aは変更しません。白黒化は0.2126R+0.7152G+0.0722Bを四捨五入して使います（色空間の厳密な輝度変換ではなく学習用の近似です）。

## 1か所変えてみる

`app.js`の`delta`の範囲を変更すると補正上限が変わります。先にHTMLのスライダー範囲とテストの期待値を確認してください。スライダーを0へ戻したときのRGB一致を回帰条件にします。

## うまく動かないとき

- 「読み込み中」のまま：`app.js`の相対パスとブラウザConsoleを確認。
- Canvasが空白：ブラウザがCanvas 2Dに対応しているか確認。
- 値が255を超えない：`Uint8ClampedArray`で範囲内へ丸められる仕様です。
- 外部の写真で試す場合：画像の権利、機密情報、別オリジン画像のCORSとSecurityErrorに注意。この教材では外部画像を扱いません。

## 仕事・学習で使うなら

写真の加工を始める前の「RGBと透明度」の教材、画像処理の比較UI、フィルタの品質検証に応用できます。色覚・表示機器差があるため、色だけで合否を伝えず数値も示します。大画像では全ピクセルを同期処理するとUIが重くなるため、縮小画像・処理時間計測・Web Worker等を検討します。

## 公式資料

- [MDN Canvasピクセル操作](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Pixel_manipulation_with_canvas)
- [MDN getImageData](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/getImageData)
- [MDN putImageData](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/putImageData)

## 検証

2026-10-31：MDNの一次資料を確認。JavaScriptのロジック検査は別途結果を記録。ブラウザ・GitHub Pages到達・WordPress青い囲み・印刷/PDF・実スマートフォンは未確認。GitHub Actionsは使用しません。
