$log='user=demo token=ABC123 password=secret';$safe=$log-replace'(token=)[^ ]+','$1***'-replace'(password=)[^ ]+','$1***';"Before: $log";"After: $safe"
