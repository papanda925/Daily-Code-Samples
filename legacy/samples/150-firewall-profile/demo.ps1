Get-NetFirewallProfile|Select Name,Enabled,DefaultInboundAction,DefaultOutboundAction
Get-NetFirewallRule|Group Profile|Select Name,Count
