$requests=0;$start=Get-Date;1..8|%{if(((Get-Date)-$start).TotalSeconds-ge5){$start=Get-Date;$requests=0};$requests++;if($requests-le3){"OK $_"}else{"LIMIT $_"};Start-Sleep 1}
