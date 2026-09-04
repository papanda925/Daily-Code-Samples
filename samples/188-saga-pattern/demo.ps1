$c=@();try{"Step1";$c+='Step1';"Step2";$c+='Step2';throw'Step3 failed'}catch{"FAIL";for($i=$c.Count-1;$i-ge0;$i--){"Compensate $($c[$i])"}}
