$g=(Get-NetRoute -DestinationPrefix '0.0.0.0/0'|Sort RouteMetric|Select -First 1).NextHop
$r=1..10|%{$p=Test-Connection $g -Count 1 -EA 0;if($p){[double]$p.Latency};Start-Sleep -Milliseconds 200}
$r|Measure-Object -Average -Minimum -Maximum
