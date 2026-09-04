foreach($n in 1,255,256,65535){$b=[BitConverter]::GetBytes([int]$n);[pscustomobject]@{Value=$n;Bytes=(($b|%{$_.ToString('X2')})-join' ')}}
