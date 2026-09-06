$line='20260904INFO USER001 Login successful';[pscustomobject]@{Date=$line.Substring(0,8);Level=$line.Substring(8,4);User=$line.Substring(13,7);Message=$line.Substring(21)}
