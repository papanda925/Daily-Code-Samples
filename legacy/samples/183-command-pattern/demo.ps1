$h=[Collections.Generic.List[object]]::new();function Invoke-Cmd($n,[scriptblock]$a){&$a;$h.Add([pscustomobject]@{Name=$n;Time=Get-Date})};Invoke-Cmd Add{'A'};Invoke-Cmd Delete{'B'};$h
