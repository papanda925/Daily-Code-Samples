$name="DailyCodePipe";$server=Start-Job -ArgumentList $name {param($n);$s=[IO.Pipes.NamedPipeServerStream]::new($n);$s.WaitForConnection();$r=[IO.StreamReader]::new($s);"SERVER: $($r.ReadLine())";$r.Dispose();$s.Dispose()}
Start-Sleep -Milliseconds 300;$c=[IO.Pipes.NamedPipeClientStream]::new(".",$name,[IO.Pipes.PipeDirection]::Out);$c.Connect();$w=[IO.StreamWriter]::new($c);$w.AutoFlush=$true;$w.WriteLine("こんにちは");$w.Dispose();$c.Dispose()
$server|Wait-Job|Receive-Job;$server|Remove-Job
