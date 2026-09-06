foreach($n in 1,25,12345){[pscustomobject]@{Value=$n;Fixed10=('{0:0000000000}'-f$n)}}
