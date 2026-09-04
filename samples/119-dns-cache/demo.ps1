Get-DnsClientCache|Select -First 10 Entry,RecordName,RecordType,TimeToLive
Resolve-DnsName example.com|Out-Null
Get-DnsClientCache|? Entry -Match 'example.com'|Select Entry,RecordName,RecordType,TimeToLive
