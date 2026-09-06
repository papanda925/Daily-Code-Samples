Get-NetNeighbor|?{$_.State-notin'Unreachable','Incomplete'}|Select InterfaceAlias,IPAddress,LinkLayerAddress,State
