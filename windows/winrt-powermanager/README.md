# PowerShellからWinRT PowerManagerで電源状態を取得する

Windows Runtimeの `Windows.System.Power.PowerManager` をPowerShellから読み込み、バッテリー残量、バッテリー状態、電源供給状態、省電力状態を表示します。

## 前提

Windows 10/11。デスクトップPCなどバッテリーを持たない環境では値の意味が異なる場合があります。

## 検証状態

Microsoft LearnのPowerManager仕様を確認して実装。対象Windows実機での再検証は未実施です。
