$a=Measure-Command{1..3|%{Start-Sleep 1}}
$b=Measure-Command{$j=1..3|%{Start-Job{Start-Sleep 1}};$j|Wait-Job|Out-Null;$j|Remove-Job}
"逐次=$([math]::Round($a.TotalSeconds,2))秒 / 並列=$([math]::Round($b.TotalSeconds,2))秒"
