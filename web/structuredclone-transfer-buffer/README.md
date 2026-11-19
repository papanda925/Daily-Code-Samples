# structuredCloneのtransferでArrayBufferがどう変わるか
JavaScriptの`structuredClone()`は通常コピーと、転送可能オブジェクトの`transfer`を指定した複製で動作が異なります。架空のバイト列を使い、元のバッファーが利用可能かを比較する教材です。

## ライブデモ
[ブラウザーで比較する](https://papanda925.github.io/Daily-Code-Samples/demos/structuredclone-transfer-buffer/)

## まず試す
1. 「通常コピー」を選び、8バイトで「比較を実行」。
2. 元`byteLength=8`、複製先`byteLength=8`を期待します。複製先の先頭を99に変更しても元は1のままです。
3. 「transfer」を選んで再実行。元`byteLength=0`、複製先`byteLength=8`を期待します。
4. バイト数を1、32へ変えて差を観察してください。

## ここを見る
- [公開HTML](../../docs/demos/structuredclone-transfer-buffer/index.html)
- [実装JavaScript](../../docs/demos/structuredclone-transfer-buffer/app.js)
- `structuredClone(original)`は元のArrayBufferと独立した複製を作ります。
- `structuredClone(original,{transfer:[original]})`は元のArrayBufferをdetachし、複製先へデータを移します。元の`byteLength`は0になります。
- transfer後に元の`Uint8Array`で要素を読み直すことはできません。既存ビューの振る舞いと例外は操作によって異なるため、実装では明示的に元バッファーの状態を確認してください。

## 1か所変える
バイト数を8から1に変更します。データの長さは変わっても、通常コピーなら元が残り、transferなら元がdetachedになる原則は同じです。

## うまくいかないとき
- `structuredClone is not defined`：古いブラウザーの可能性。更新または対応状況を確認します。
- `DataCloneError`：転送できないオブジェクトをtransferへ指定した可能性。ArrayBufferを使っているか確認します。
- `byteLength=0`：transfer実行後の元バッファーでは正常です。バグと判断せず、複製先を利用してください。
- 入力範囲外：1〜32へ戻します。

## 仕事で使うなら
Workerへの大きなバイナリデータ受渡しなど、元データを以後使わない場面でtransferを検討します。コピーと違い、元が利用不能になるため、所有権の受渡しを設計で明示してください。転送は暗号化や情報漏えい対策ではありません。

## 安全・検証
通信、権限要求、外部API、CDN、永続保存なし。実行はブラウザーでのユーザー操作のみ。コードの静的確認を実施し、実ブラウザー操作とPages URL到達は未確認です。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Window/structuredClone
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Transferable_objects

対応記事ID：20261120-03（WordPress公開は別工程）。
