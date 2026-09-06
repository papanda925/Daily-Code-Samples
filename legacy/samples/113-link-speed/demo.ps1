Get-NetAdapter|? Status -eq Up|Select Name,LinkSpeed,MacAddress
"LinkSpeedは実効転送速度そのものではありません"
