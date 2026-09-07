# TCPのSend回数とReceive回数は1対1ではない

アプリ側では2回 `Write()` し、受信側では2バイトの小さいバッファで7バイトを読みます。これにより「送信APIを2回呼んだから、受信APIも2回で返る」と設計してはいけないことを目で確認します。

## 大事な点

TCPはアプリケーションメッセージの境界を保存するAPIではなく、順序付きバイトストリームとして扱います。このデモは**ネットワーク上のパケット分割パターンを再現するものではありません**。

受信バッファを2バイトに固定しているので、合計7バイトを受け取るため `Read()` は最低4回必要です。これで「Send呼び出し回数 = Read呼び出し回数」という前提が安全でないことを再現可能に確認します。

## 1か所変えてみる

`New-Object byte[] 2` を `New-Object byte[] 4` に変え、Read回数を比較します。

## 実務では

アプリ側のメッセージ境界が必要なら、改行区切り、固定長、length-prefixなどの framing を別途設計します。

## 検証状態

RFC 9293とMicrosoft LearnのSocket/NetworkStream仕様を確認して実装。このセッションではWindows/PowerShell実機未確認です。

## 公式情報

- RFC 9293 — Transmission Control Protocol: https://www.rfc-editor.org/rfc/rfc9293.html
- Microsoft Learn — Socket.Receive: https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.socket.receive
