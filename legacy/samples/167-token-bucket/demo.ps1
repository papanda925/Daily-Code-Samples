$capacity=5;$tokens=5;1..10|%{if($tokens-gt0){$tokens--;"request $_ -> OK tokens=$tokens"}else{"request $_ -> WAIT";Start-Sleep 1;$tokens=[math]::Min($capacity,$tokens+2)}}
