# UTF-8の途中で分割された文字を安全に復号する

日本語や絵文字を含む通信データが複数のチャンクに分かれた場合、`TextDecoder`の`stream: true`がなぜ必要なのかを、実際のバイト数と結果で比較する教材です。

## ライブデモ

[ブラウザーで比較する](https://papanda925.github.io/Daily-Code-Samples/demos/textdecoder-stream-split/)

実装は [index.html](../../docs/demos/textdecoder-stream-split/index.html) と [app.js](../../docs/demos/textdecoder-stream-split/app.js) にあります。GitHub Pagesの反映・URL到達は未確認です。

## 実行方法

1. Chrome / Edge / Firefox等の現代的なブラウザーでデモを開く。通信できない場合は2ファイルを同じフォルダに保存してindex.htmlを開く。
2. 「前半のバイト数」を2として「比較する」を押す。
3. `個別decode` と `stream:true` の表示を比較する。
4. 分割位置を1、3、4などへ変更し、置換文字が現れる条件を調べる。

外部API・CDN・権限・ログイン・保存領域・個人データは使いません。

## 観察すること

元文字列は「東京🍣の受付番号」。UTF-8の各文字は1〜4バイトです。初期値の2は「東」の3バイトの途中で分割するため、チャンクを別々に復号すると置換文字が入ります。一方、同一decoderで`stream:true`を使うと、未完成のバイト列を次回まで保持して元の文字列に戻ります。分割位置が文字境界なら両方式が同じになることもあります。

| 条件 | 個別decode | stream:true |
|---|---|---|
| 2バイト目で分割 | 置換文字が入る | 元の文字列と一致 |
| UTF-8文字の境界で分割 | 元の文字列と一致 | 元の文字列と一致 |
| 0や範囲外 | 入力エラー表示 | 入力エラー表示 |

## 仕組み

`TextEncoder`は文字列をUTF-8バイト列に変換します。`TextDecoder.decode(chunk)`をチャンクごとに新しいインスタンスで呼ぶと、チャンク末尾の不完全な文字を持ち越せません。`TextDecoder.decode(chunk,{stream:true})`を**同じインスタンス**で順に呼び、最後に引数なしの`decode()`で終了処理を行います。streamは通信を発生させる設定ではなく、復号器の状態を保持する指定です。

実務ではFetchのReadableStreamやファイルの分割読み取りで、受信バイト列の境界が文字境界と一致しないときに重要です。分割した文字列を結合するだけでは、失われたバイトを復元できません。

## うまくいかないとき

- ボタンが動かない：app.jsの相対パスとブラウザーのコンソールを確認。
- 両方同じ表示：UTF-8文字境界で分割している可能性があるので2へ変更。
- `�`が表示される：個別decodeの意図した比較結果。stream側にも出るなら元データの不正バイト、decoderの使い回し、最後のflushを確認。
- 入力エラー：1以上、最大値以下の整数を指定する。

## 安全性と検証

架空の文字列のみを使用。入力は画面内のバイト位置だけで、送信・保存しません。依存ライブラリはなく、標準ブラウザーAPIのみ。JavaScript構文とロジックの静的確認を実施、ブラウザーでの実クリック・GitHub Pages到達・WordPress埋込は未検証です。

公式資料：[MDN TextDecoder.decode](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder/decode) / [Encoding Standard](https://encoding.spec.whatwg.org/#interface-textdecoder)

関連ブログ記事ID：20261119-08。記事は判断と操作の流れを説明し、この教材は分割位置を変える実験を提供します。
