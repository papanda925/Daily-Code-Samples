$before=(Get-Process -Id $PID).HandleCount
$p=Join-Path $env:TEMP "handle-demo.txt";$fs=[IO.File]::Open($p,'OpenOrCreate','ReadWrite','Read')
"Before=$before / Open中=$((Get-Process -Id $PID).HandleCount)";$fs.Dispose();Remove-Item $p -ErrorAction SilentlyContinue
