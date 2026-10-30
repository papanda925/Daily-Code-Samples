# Web Animations APIで荷物カードを動かす

外部ライブラリを使わず、ブラウザ標準の Element.animate() と Animation の制御を練習する教材です。架空の荷物カードのみ。個人情報・APIキー・外部送信・音声はありません。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/web-animations-parcel-controls/

GitHub Pagesへの反映・実ブラウザでの動作は未確認です。404の場合は下記のHTMLとJavaScriptを同じフォルダへ保存してローカルで開いてください。

## まず試す

1. docs/demos/web-animations-parcel-controls/index.html を開く。
2. 「再生」でカードの左右への往復を観察する。
3. 1倍から2倍へ変え、スピードの差を確かめる。
4. 「一時停止」と「リセット」で位置と状態欄の変化を比べる。

## 期待結果（実ブラウザ未確認）

| 操作 | 予想する状態 |
| --- | --- |
| 起動直後 | 準備完了、1倍で停止 |
| 再生 | 左右へ往復、状態表示が再生中 |
| 速度2倍 | 同じ距離を速く移動 |
| 一時停止 | その場で停止 |
| リセット | 出発位置で停止 |
| 動き軽減が有効 | 静止表示・再生操作無効 |

## 1か所変更

JavaScriptの duration: 2600 を duration: 1300 にすると、往復の片道時間が短くなると予想できます。速度は1倍に固定してから比較し、終わったら元に戻します。

## 失敗・安全

- 読み込み中のまま: app.js のパス・開発者ツールConsoleを確認。
- 動かない: OSの動き軽減設定とElement.animate()対応を確認。
- サイズを変えると出発位置へ戻る: レールの横幅再計算のための意図的なリセット。
- アニメーションの重複を防ぐため、作り直す前にcancel()する。
- 画面を開いただけでは自動再生せず、端末の動き軽減設定を尊重します。
- 実ブラウザ・GitHub Pages到達・モバイル互換性・WordPress記事の描画は未検証。

## 公式資料（2026-10-31確認）

- https://developer.mozilla.org/ja/docs/Web/API/Element/animate
- https://developer.mozilla.org/ja/docs/Web/API/Animation
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API/Using_the_Web_Animations_API
- https://developer.mozilla.org/ja/docs/Web/CSS/Reference/At-rules/%40media/prefers-reduced-motion

## ファイル

- docs/demos/web-animations-parcel-controls/index.html（画面とCSS）
- docs/demos/web-animations-parcel-controls/app.js（制御処理）
