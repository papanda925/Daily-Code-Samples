$alphabet=62;foreach($len in 6,8,10,12,16){[pscustomobject]@{Length=$len;Combinations=[Numerics.BigInteger]::Pow([Numerics.BigInteger]$alphabet,$len)}}
