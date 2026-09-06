# PowerShellからWinRT PowerManagerで電源状態を取得する

Windows Runtimeの `Windows.System.Power.PowerManager` をPowerShellから読み込み、バッテリー残量、バッテリー状態、電源供給状態、省電力状態を表示します。

## 前提

この最小サンプルは **Windows PowerShell 5.1 + Windows 10/11** を対象にします。

Windows PowerShell 5.1では `ContentType = WindowsRuntime` を使ってWinRT型を直接解決できます。PowerShell 7系ではWinRTの相互運用方法や利用可能性が異なるため、このコードをそのまま共通サンプルとはしません。PowerShell 7で試す場合はWindows SDK for .NET等の利用方法を別途確認してください。

デスクトップPCなどバッテリーを持たない環境では値の意味が異なる場合があります。

## 検証状態

Microsoft LearnのPowerManager仕様を確認して実装。対象Windows実機での再検証は未実施です。
