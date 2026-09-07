# PowerShellでHTTP/1.1をTCPの上へ生で送る

HTTPクライアントAPIを使わず、localhostのTCP接続へHTTP/1.1メッセージを書き込む教材です。

## 構成

- `Start-LocalHttpServer.ps1` — 127.0.0.1:8085で1回だけ待ち受ける簡易HTTPサーバー
- `Invoke-RawHttp.ps1` — TCP接続し、HTTP/1.1のGETリクエストを文字列として送るクライアント

外部サイトへ接続せず、1台のPCだけでHTTPとTCPの関係を観察できます。

## 実行

PowerShellを2つ開きます。

### 1. サーバー側

```powershell
./Start-LocalHttpServer.ps1
```

`LISTEN 127.0.0.1:8085` と表示されたら待機中です。

### 2. クライアント側

```powershell
./Invoke-RawHttp.ps1
```

サーバー側には受信したrequest lineとheaders、クライアント側にはHTTPの生レスポンスが表示されます。

## 学習ポイント

HTTP/1.1メッセージは、start-line、header fields、空行、必要に応じたbodyで構成されます。HTTP/1.1ではHost headerが必要です。この教材では `TcpClient` の `NetworkStream` へASCIIのHTTPメッセージを書き込みます。

HTTPSはここへTLS層が加わるため、このサンプルでは扱いません。

## 検証状態

RFC 9112と.NETのTcpClient / NetworkStream公式仕様を確認して実装。対象PowerShell環境での実行確認は未実施です。

## 公式・一次情報

- [RFC 9112 — HTTP/1.1](https://www.rfc-editor.org/rfc/rfc9112.html)
- [TcpClient.GetStream — Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.tcpclient.getstream?view=net-10.0)
