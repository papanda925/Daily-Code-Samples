$v='normal','=1+1','+SUM(A1:A2)','@demo';$v|%{[pscustomobject]@{Original=$_;AsText=if($_-match'^[=+\-@]'){"'"+$_}else{$_}}}|ConvertTo-Csv -NoTypeInformation
