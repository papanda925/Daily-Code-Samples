# PowerShellからWin32の電源状態を読む

`GetSystemPowerStatus` をP/Invokeし、設定変更なしでAC電源・バッテリー状態を観察する教材です。

- `Get-PowerStatus.ps1` を通常権限のPowerShellで実行します。
- `BatteryLifePercent=255` は「255%」ではなく未知値として扱います。
- デスクトップ、仮想環境、バッテリー非搭載機では意味のある残量が得られない場合があります。

検証状態: implemented / 実機未検証。

公式: https://learn.microsoft.com/windows/win32/api/winbase/nf-winbase-getsystempowerstatus
