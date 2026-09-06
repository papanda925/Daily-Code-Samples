$c=@{};$s=@{A='from-store'};function GetV($k){if($c.ContainsKey($k)){"cache hit";return$c[$k]};"cache miss";$v=$s[$k];$c[$k]=$v;$v};GetV A;GetV A
