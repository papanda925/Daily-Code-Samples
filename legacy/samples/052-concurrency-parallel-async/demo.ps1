"Concurrency=複数の仕事を進行中にする / Parallelism=同時実行 / Async=待ちを占有しない"
$j=Start-Job{Start-Sleep 2;"done"}
"foreground continues"
$j|Wait-Job|Receive-Job;$j|Remove-Job
