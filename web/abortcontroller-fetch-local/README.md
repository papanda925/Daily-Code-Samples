# AbortControllerでfetchを中断する

Node.js 18以上の標準fetchとHTTPサーバーのみ。`127.0.0.1`の空いているランダムポートに待受け、外部通信を行いません。

```bash
node abort-demo.js
```

サーバーは400ms待ってレスポンスを返します。1回目のfetchは100msで手動abortされ、2回目は正常取得します。

期待出力（実機未検証）:

```text
First request: AbortError (cancelled by client)
Second request: 200 finished
```

1回目のabortは**呼び出し側の待機を中断**します。サーバー側の処理が自動で停止するとは限りません。タイマー解除、`server.close`による終了処理を含みます。

`AbortController.abort()`で発生したAbortErrorと、`AbortSignal.timeout()`によるTimeoutErrorを同一視しないでください。通信失敗時は一般のTypeErrorなどになる場合もあります。

公式情報:
- https://developer.mozilla.org/en-US/docs/Web/API/AbortController
- https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/timeout_static
- https://nodejs.org/api/globals.html#fetch
