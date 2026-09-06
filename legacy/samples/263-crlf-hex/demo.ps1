$s="A"+[char]13+[char]10+"B";$b=[Text.Encoding]::ASCII.GetBytes($s);($b|%{$_.ToString('X2')})-join' '
