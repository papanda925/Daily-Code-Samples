param([string]$Path="$env:WINDIR\win.ini");$fs=[IO.File]::OpenRead($Path);try{$buf=New-Object byte[] 16;while(($n=$fs.Read($buf,0,$buf.Length))-gt0){"Read $n bytes"}}finally{$fs.Dispose()}
