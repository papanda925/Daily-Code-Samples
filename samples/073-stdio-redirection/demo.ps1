$o=Join-Path $env:TEMP "stdout.txt";$e=Join-Path $env:TEMP "stderr.txt";$p=Start-Process cmd -ArgumentList '/c','echo OUT & echo ERR 1>&2' -Wait -PassThru -RedirectStandardOutput $o -RedirectStandardError $e
"Code=$($p.ExitCode)";Get-Content $o;Get-Content $e;Remove-Item $o,$e
