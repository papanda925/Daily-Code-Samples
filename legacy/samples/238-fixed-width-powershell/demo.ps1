$line='01PAPANDA925          0000010000';[pscustomobject]@{Type=$line.Substring(0,2);Name=$line.Substring(2,20).Trim();Amount=[int]$line.Substring(22,10)}
