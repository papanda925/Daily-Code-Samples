$expected=32;'12345678901234567890123456789012','short'|%{[pscustomobject]@{Line=$_;Length=$_.Length;Valid=($_.Length-eq$expected)}}
