$a="A"+[char]13+[char]10+"B";$b="A"+[char]10+"B";[pscustomobject]@{CRLFBytes=([Text.Encoding]::ASCII.GetBytes($a)-join' ');LFBytes=([Text.Encoding]::ASCII.GetBytes($b)-join' ')}
