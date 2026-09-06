$p=Join-Path $env:TEMP 'demo.ini';@('[app]','name=DailyCode','mode=test')|Set-Content $p;Get-Content $p;Remove-Item $p
