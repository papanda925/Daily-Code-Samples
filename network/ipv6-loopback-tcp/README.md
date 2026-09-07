# IPv6のlocalhost `::1` でTCP通信する

1台のWindows PC内だけでIPv6 TCPのサーバーとクライアントを動かし、`HELLO_IPV6` / `ACK_IPV6` を往復させる学習用サンプルです。

## 成功条件

最後に次が出れば成功です。

```text
[SUCCESS] ::1 だけでIPv6 TCPの往復通信を確認しました
```

## ここを見る

- server/client endpointが `[::1]:ポート` の形になる
- client側を `AddressFamily.InterNetworkV6` で作る
- `DualMode = $false` にしてIPv6だけのSmoke Testにする
- TCPの接続・送信・受信・切断の流れ自体はIPv4とよく似ている

## 実行

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Test-Ipv6LoopbackTcp.ps1
```

## 1か所変えてみる

`-Port 48062` のようにポートだけ変えて再実行します。

## 検証状態

RFC 4291とMicrosoft LearnのSocket/TcpClient仕様を確認して実装。このセッションではWindows/PowerShell実機未確認です。

## 公式情報

- RFC 4291 — IPv6 Addressing Architecture: https://www.rfc-editor.org/rfc/rfc4291.html
- Microsoft Learn — TcpClient(AddressFamily): https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.tcpclient.-ctor
- Microsoft Learn — Socket.DualMode: https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.socket.dualmode
