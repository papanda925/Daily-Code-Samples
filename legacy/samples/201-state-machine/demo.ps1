$a=@{未申請=@('申請済');申請済=@('承認','却下');承認=@('完了');却下=@();完了=@()};function Move($f,$t){[pscustomobject]@{From=$f;To=$t;Allowed=($a[$f]-contains$t)}};Move '未申請' '申請済';Move '未申請' '完了'
