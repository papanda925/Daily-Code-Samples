$path=Join-Path $env:TEMP "race-demo.txt";"0"|Set-Content $path
$j=1..4|%{Start-Job -ArgumentList $path {param($p);1..50|%{$n=[int](Get-Content $p);Start-Sleep -Milliseconds(Get-Random -Maximum 5);($n+1)|Set-Content $p}}}
$j|Wait-Job|Out-Null;"期待値=200 / 実際=$(Get-Content $path)";$j|Remove-Job;Remove-Item $path -ErrorAction SilentlyContinue
