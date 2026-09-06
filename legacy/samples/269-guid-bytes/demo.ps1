$g=[guid]::NewGuid();[pscustomobject]@{Guid=$g;Bytes=(($g.ToByteArray()|%{$_.ToString('X2')})-join' ')}
