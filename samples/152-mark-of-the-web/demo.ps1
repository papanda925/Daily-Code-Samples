param([string]$Path=(Join-Path $env:TEMP 'motw-demo.txt'));if(!(Test-Path $Path)){'demo'|Set-Content $Path};Get-Content -Path $Path -Stream Zone.Identifier -EA 0;"自分でダウンロードしたファイルをPath指定して比較"
