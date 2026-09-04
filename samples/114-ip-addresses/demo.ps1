Get-NetIPAddress|? AddressState -eq Preferred|Select InterfaceAlias,AddressFamily,IPAddress,PrefixLength
