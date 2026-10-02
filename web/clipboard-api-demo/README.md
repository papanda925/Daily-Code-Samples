# Clipboard API ライブデモ

ボタンを押したときだけ `navigator.clipboard.writeText()` を呼び、成功・失敗を画面へ表示する最小デモです。

## 試し方

GitHub PagesなどのHTTPS環境で `index.html` を開き、文字を入力して「コピー」を押します。成功時は `SUCCESS`、失敗時は例外名を表示します。

- 自動実行しません。
- 入力内容を外部serverへ送信・保存しません。
- browserや権限状態によりClipboard APIが利用できない場合があります。

[MDN — Clipboard: writeText()](https://developer.mozilla.org/docs/Web/API/Clipboard/writeText)

検証状態: API仕様確認済み。browser実機再確認は未実施。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/clipboard-api-demo/
