$p=Join-Path $env:TEMP 'ads-demo.txt';'main'|Set-Content $p;'demo stream'|Set-Content $p -Stream Demo;Get-Item $p -Stream *;Get-Content $p -Stream Demo;Remove-Item $p -Force
