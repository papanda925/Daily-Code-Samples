# PowerShellからWinRT PowerManagerで電源状態を観察する

Windows Runtime の `Windows.System.Power.PowerManager` を Windows PowerShell 5.1 から直接読み込み、バッテリー残量・電源供給状態・省電力状態を表示します。

## 今回の成功条件

`[SUCCESS]` が表示され、`RemainingChargePercent` などの `[RESULT]` が1つ以上取得できれば Smoke Test 成功です。

## 実行

Windows PowerShell 5.1 で実行します。

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Get-PowerState.ps1
```

## ここを見る

- `RemainingChargePercent`
- `BatteryStatus`
- `PowerSupplyStatus`
- `EnergySaverStatus`
- `RemainingDischargeTime`

デスクトップPCなどバッテリーを持たない環境では、一部の値がノートPCとは異なる場合があります。

## 1か所変えてみる

ノートPCで安全に試せるなら、ACアダプター接続時とバッテリー駆動時で値を比較します。

## 注意

- 対象は **Windows PowerShell 5.1 + Windows 10/11** です。
- PowerShell 7系では WinRT 相互運用の扱いが異なるため、このサンプルをそのまま共通版とはしません。
- このセッションにはWindows実機がないため、Microsoft LearnのAPI仕様確認とコードレビューまでです。実機確認済みとは扱いません。

## 公式情報

- Microsoft Learn — PowerManager: https://learn.microsoft.com/en-us/uwp/api/windows.system.power.powermanager?view=winrt-26100
- Microsoft Learn — RemainingChargePercent: https://learn.microsoft.com/en-us/uwp/api/windows.system.power.powermanager.remainingchargepercent?view=winrt-26100
