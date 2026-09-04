$p=Join-Path $env:TEMP "file-lock-demo.txt";"demo"|Set-Content $p;$fs=[IO.File]::Open($p,'Open','ReadWrite','None')
try{try{$x=[IO.File]::OpenRead($p);$x.Dispose()}catch{"2回目OPEN失敗: $($_.Exception.Message)"}}finally{$fs.Dispose();Remove-Item $p}
