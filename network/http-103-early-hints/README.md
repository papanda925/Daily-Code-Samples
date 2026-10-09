# HTTP 103 Early Hintsをlocalhostで観察

Node.js **18.11以降**。`node:http`標準モジュールだけで動き、`127.0.0.1:30031`にのみ待ち受けます。

端末A:

```bash
node early-hints-local.js
```

端末B:

```bash
curl --http1.1 --include --no-progress-meter http://127.0.0.1:30031/
```

期待するHTTPレスポンス（クライアントのバージョンなどで表示差あり）:

```text
HTTP/1.1 103 Early Hints
Link: </style.css>; rel=preload; as=style

HTTP/1.1 200 OK
...
```

最後は端末AでCtrl+C。外部への通信、ファイル書込み、管理者権限はありません。

`res.writeEarlyHints()`は103という情報応答を先行送信しますが、クライアントが必ずファイルを先読みするわけではありません。200は最終応答で、HTTP 103はエラーやリダイレクトではありません。

- https://nodejs.org/api/http.html#responsewriteearlyhintshints-callback
- https://www.rfc-editor.org/rfc/rfc8297.html

**検証状態：公式API/仕様確認済み。localhost実機テスト未実施。**
