Get-NetRoute -DestinationPrefix '0.0.0.0/0' -EA 0|Select InterfaceAlias,NextHop,RouteMetric
Get-NetRoute -DestinationPrefix '::/0' -EA 0|Select InterfaceAlias,NextHop,RouteMetric
