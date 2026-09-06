Get-NetTCPConnection -State Listen|Sort LocalPort|Select LocalAddress,LocalPort,OwningProcess
