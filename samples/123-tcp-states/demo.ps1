Get-NetTCPConnection|Group State|Sort Count -Descending|Select Name,Count
Get-NetTCPConnection|Select -First 30 State,LocalAddress,LocalPort,RemoteAddress,RemotePort,OwningProcess
