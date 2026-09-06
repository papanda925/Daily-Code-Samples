$done=@{};function Run($n,$deps){foreach($d in$deps){if(-not$done[$d]){throw"$n waits $d"}};"RUN $n";$done[$n]=$true};Run A @();Run B @('A');Run C @('A');Run D @('B','C')
