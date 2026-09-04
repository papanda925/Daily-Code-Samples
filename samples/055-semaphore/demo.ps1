$name="Global\DailyCodeSemaphoreDemo"
$j=1..5|%{Start-Job -ArgumentList $name,$_ {param($n,$id);$c=$false;$s=New-Object Threading.Semaphore(2,2,$n,[ref]$c);[void]$s.WaitOne();try{"RUN $id";Start-Sleep 2}finally{"END $id";$s.Release()|Out-Null;$s.Dispose()}}}
$j|Wait-Job|Receive-Job;$j|Remove-Job
