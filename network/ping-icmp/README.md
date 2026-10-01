# PowerShellでICMP Echoの往復を観察する

System.Net.NetworkInformation.Ping を使い、まず 127.0.0.1 だけへICMP Echoを送り、status・応答先・往復時間を観察する教材です。

## まず試す

~~~powershell
./Test-IcmpEcho.ps1
~~~

既定はloopbackなので外部通信はしません。別の宛先を確認したい場合だけ明示します。

~~~powershell
./Test-IcmpEcho.ps1 -Target "example.com" -Count 3
~~~

## ここを見る

- Status: Success / TimedOut等
- Address: 実際に応答したアドレス
- RoundtripTimeMs: 往復時間
- BufferBytes: 応答データ長

Ping成功は「そのICMP Echoに応答した」ことの観察です。HTTP、RDP、データベース等のアプリケーションが正常とは限りません。逆にICMPを遮断している機器では、サービスが生きていてもPingが失敗し得ます。

## 検証状態

.NET PingとICMPの公式仕様を確認した教材です。この更新時点でPowerShell実機実行はしていません。

## 公式情報

- [Microsoft Learn — System.Net.NetworkInformation.Ping](https://learn.microsoft.com/en-us/dotnet/api/system.net.networkinformation.ping)
- [RFC 792 — Internet Control Message Protocol](https://www.rfc-editor.org/rfc/rfc792.html)
