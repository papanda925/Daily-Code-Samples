$n='A','B','C';function Pick($k,$nodes){$h=[math]::Abs($k.GetHashCode());$nodes[$h%$nodes.Count]};'alpha','beta','gamma','delta'|%{"$_ -> $(Pick $_ $n)"}
