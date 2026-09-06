"PnPのStatusとWindows設定画面の接続表示を比較"
if(Get-Command Get-PnpDevice -EA 0){Get-PnpDevice -Class Bluetooth -EA 0|Select Status,FriendlyName,InstanceId}
