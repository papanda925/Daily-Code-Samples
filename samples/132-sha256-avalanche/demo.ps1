$a=[Text.Encoding]::UTF8.GetBytes('ABC');$b=[Text.Encoding]::UTF8.GetBytes('ABD')
$sha=[Security.Cryptography.SHA256]::Create();try{$ha=[Convert]::ToHexString($sha.ComputeHash($a));$hb=[Convert]::ToHexString($sha.ComputeHash($b));$ha;$hb;"異なるHex文字数="+(0..($ha.Length-1)|?{$ha[$_] -ne $hb[$_]}).Count}finally{$sha.Dispose()}
