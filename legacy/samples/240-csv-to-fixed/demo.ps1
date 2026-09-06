$rows=@([pscustomobject]@{Type='01';Name='PAPANDA925';Amount=10000},[pscustomobject]@{Type='01';Name='SAMPLE';Amount=2500});$rows|%{"{0}{1,-20}{2:0000000000}"-f$_.Type,$_.Name,$_.Amount}
