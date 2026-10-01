# DNSのTXTレコードをPowerShellで切り分ける

Microsoft 365等のドメイン確認でTXTを追加したのに外から見えないとき、NS → 通常の再帰DNS → 指定したDNSサーバーの順に応答を比べる読み取り専用サンプルです。

## まず試す

~~~powershell
./Check-DnsTxt.ps1 -Domain "example.com"
~~~

権威DNSサーバー名が分かっている場合は追加します。

~~~powershell
./Check-DnsTxt.ps1 -Domain "example.com" -Server "ns1.example.net"
~~~

実テナントの検証トークンをこのGitHubリポジトリへ保存しないでください。

## ここを見る

1. NSレコードで、どのDNS事業者が権威を持っているか
2. 通常の Resolve-DnsName -Type TXT で、普段の再帰DNSから何が見えるか
3. -Server 指定時に、そのDNSサーバーから何が返るか

権威側には新しいTXTが見え、再帰DNSでは古い応答が残るなら、キャッシュ/TTLの影響を疑う手掛かりになります。両方に見えない場合は、ゾーンや入力値、保存先の確認へ戻ります。

## 1か所変える

まず -Server なしで実行し、その後サーバー指定だけを追加します。ドメイン名まで同時に変えないでください。

## 注意

- -Server に指定したDNSが本当に対象ゾーンの権威DNSかはNSレコードとDNS事業者の情報で確認します。
- 「何分待てば必ず反映」と固定時間で断定しません。
- 実際のMicrosoft 365検証値や内部DNS名を記事・Issueへ貼らないでください。

## 検証状態

Microsoft LearnのResolve-DnsNameとMicrosoft 365ドメイン確認資料を確認して更新しています。対象テナント/DNSでの実機変更・反映確認は行っていません。

## 公式情報

- [Microsoft Learn — Resolve-DnsName](https://learn.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname)
- [Microsoft Learn — Add a domain to Microsoft 365](https://learn.microsoft.com/en-us/microsoft-365/admin/setup/add-domain)
