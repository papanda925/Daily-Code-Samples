$note='line1'+[Environment]::NewLine+'line2';$x=[pscustomobject]@{Name='A,B';Quote='He said "Hello"';Memo=$note};$x|ConvertTo-Csv -NoTypeInformation
