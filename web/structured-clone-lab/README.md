# JavaScriptの浅いコピーとstructuredCloneを比べる

## できること
入れ子のオブジェクトで浅いコピー `{...object}` と深いコピー `structuredClone()` の違いを実験します。固定の架空データだけを使い、通信・保存・個人情報入力・CDN・APIキーはありません。

## 環境と起動
`structuredClone` に対応する現代的ブラウザー、またはNode.js 18以降。リポジトリのルートで `python3 -m http.server 8000` を実行し、`http://127.0.0.1:8000/web/structured-clone-lab/` を開きます。終了はCtrl+C。Nodeテストは `cd web/structured-clone-lab && node --test test.cjs`。Linux Node.js 22.16.0の同等ロジック10条件でPASS（ローカル検証）。GitHub保存版の再実行と実ブラウザー試験は未実施。

## 操作と観察
「もう一度比較する」を押します。浅いコピーの入れ子をredにすると元データもredに変わります。深いコピー側をgreenに変えても元データはredのまま。Date/Mapは保持され、JSON変換ではDateはstring、Mapは空オブジェクトになります。**深いコピーが浅いコピーによる変更を取り消すわけではありません。**

## 失敗と制限
`structuredClone` 非対応ならブラウザーを更新。関数・DOM要素などは複製できず `DataCloneError` になることがあります。循環参照は対応。独自クラスのプロトタイプなどは保持されません。大量データの複製はメモリーを使うので、必要な範囲に限定します。実際の業務データをこのデモに入力しないでください。

## 仕事への応用
設定画面の「変更前／変更後」の比較や、画面で編集するデータのプレビューで元データを壊さないようにコピー方法を選びます。

## 検証範囲
Node.js 22.16.0/Linuxで同等の純粋ロジック10条件PASS。GitHub main保存版のNode再テスト、実ブラウザー、GitHub Pages公開URL、WordPress表示、Windows/macOSは未確認。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Window/structuredClone
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
