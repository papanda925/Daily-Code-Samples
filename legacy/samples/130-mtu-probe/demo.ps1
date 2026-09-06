$g=(Get-NetRoute -DestinationPrefix '0.0.0.0/0'|Sort RouteMetric|Select -First 1).NextHop
foreach($s in 1200,1400,1472,1500){"=== $s ===";ping.exe -n 1 -f -l $s $g}
