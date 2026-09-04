foreach($x in 'report-2026.txt','../secret.txt','bad|name.txt'){[pscustomobject]@{Input=$x;Valid=($x-match'^[A-Za-z0-9._-]+$')}}
