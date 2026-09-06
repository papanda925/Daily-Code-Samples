foreach($x in 0.1,1.0,-2.5,[double]::NaN){$b=[BitConverter]::GetBytes([double]$x);[pscustomobject]@{Value=$x;Hex=(($b|%{$_.ToString('X2')})-join' ')}}
