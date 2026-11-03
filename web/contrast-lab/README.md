# WCAG 2.2 コントラスト比を体験する教材
色の見た目だけで判断せず、文字色と背景色の相対輝度を比較します。外部ライブラリ・APIキー・CDN・外部送信・保存なし。架空の色だけを扱います。

## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/contrast-lab/
**GitHub Pages公開URLへの到達・実ブラウザー動作は未確認です。** 代替は下のローカル起動です。

## 対象環境
標準HTML/CSS/JavaScriptに対応する現代的ブラウザー。OS固有のAPIなし。実ブラウザー試験は未実施。計算ロジックはオフラインV8でテスト。Node.jsの `node --test` は別途実行してください。

## 起動
リポジトリのルートで `python3 -m http.server 8000` を起動し、`http://127.0.0.1:8000/web/contrast-lab/` を開きます。終了は Ctrl+C。ローカル `index.html` 直接表示も設計上可能ですが、ブラウザー環境での確認は未実施です。

## 操作と期待結果
1. 「黒と白」→ 21.00:1、AA通常文字適合。
2. 「灰色 #777777」→ 約4.48:1、AA通常文字未達。
3. 「灰色 #767676」→ 約4.54:1、AA通常文字適合。
4. 「文字色と背景色を交換」→ コントラスト比は同じ。
5. 色選択を変え、見本の読みやすさと数値を比較。判定は丸め前の値を使用。

## 構成
- `contrast.js`：純粋な計算関数。厳密な `#RRGGBB` を受け取り、相対輝度とコントラスト比を計算。
- `app.js`：入力・プレビュー・文字での合否表示。HTML文字列を挿入しない。
- `index.html`：ラベル付き入力とキーボード操作可能なUI。
- `test.mjs`：Node標準テスト、固定入力と異常系。
- `docs/demos/contrast-lab/`：同じデモのPages配置物。

## 検証
今回のChatGPT実行では隔離V8ロジック検証10条件PASS。Node標準テスト・ブラウザーDOM・Pages公開・WordPress表示・スクリーンリーダーは未実行。Linux/Windows/macOSでの実ブラウザー動作は保証しません。

## 注意
WCAG 2.2の文字コントラスト基準は通常文字AA 4.5:1、大きな文字AA 3:1、通常文字AAA 7:1です。例外・大きな文字の定義・非テキストUIは公式資料を参照。透明度、背景画像、グラデーション、フォント、操作性などはこの教材だけでアクセシビリティ適合と判定できません。

## 公式資料
- W3C WCAG 2.2: https://www.w3.org/TR/WCAG22/
- W3C Understanding Contrast Minimum: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- MDN Color contrast: https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast
