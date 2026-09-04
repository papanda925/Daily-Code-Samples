$tab=[char]9;$rows=@([pscustomobject]@{Name='A,B';Value=1},[pscustomobject]@{Name='C';Value=2});$rows|%{$_.Name+$tab+$_.Value}
