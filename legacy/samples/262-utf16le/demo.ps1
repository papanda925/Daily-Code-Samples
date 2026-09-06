$b=[Text.Encoding]::Unicode.GetBytes('ABあ');($b|%{$_.ToString('X2')})-join' '
