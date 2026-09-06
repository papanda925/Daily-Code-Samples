$n=0x12345678;$le=[BitConverter]::GetBytes([int]$n);"LE="+(($le|%{$_.ToString('X2')})-join' ');"BE="+((($le|Select-Object -Reverse)|%{$_.ToString('X2')})-join' ')
