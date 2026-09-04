$w=[Windows.Devices.Bluetooth.Advertisement.BluetoothLEAdvertisementWatcher,Windows.Devices.Bluetooth,ContentType=WindowsRuntime]::new()
$s=Register-ObjectEvent $w Received -Action{$e=$Event.SourceEventArgs;"RSSI=$($e.RawSignalStrengthInDBm) Address=$('{0:X}'-f$e.BluetoothAddress)"}
$w.Start();Start-Sleep 10;$w.Stop();Unregister-Event $s.Name
