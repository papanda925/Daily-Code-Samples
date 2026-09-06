Get-NetRoute|Sort AddressFamily,RouteMetric|Select -First 40 AddressFamily,DestinationPrefix,NextHop,InterfaceAlias,RouteMetric
