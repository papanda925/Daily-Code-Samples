$p=Join-Path $env:TEMP 'bom.txt';[IO.File]::WriteAllText($p,'ABC',[Text.UTF8Encoding]::new($true));$b=[IO.File]::ReadAllBytes($p);($b[0..4]|%{$_.ToString('X2')})-join' ';Remove-Item $p
