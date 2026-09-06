$port=8085;$l=[Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback,$port);$l.Start();"http://127.0.0.1:$port/ を開く"
$c=$l.AcceptTcpClient();$s=$c.GetStream();$r=[IO.StreamReader]::new($s);while(($line=$r.ReadLine())-ne""){"REQUEST> $line"}
$body="Hello from PowerShell";$nl=[Environment]::NewLine
$resp="HTTP/1.1 200 OK"+$nl+"Content-Type: text/plain; charset=utf-8"+$nl+"Content-Length: "+[Text.Encoding]::UTF8.GetByteCount($body)+$nl+"Connection: close"+$nl+$nl+$body
$b=[Text.Encoding]::UTF8.GetBytes($resp);$s.Write($b,0,$b.Length);$c.Dispose();$l.Stop()
