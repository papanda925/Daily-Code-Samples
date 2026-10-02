# Get-WinEventとイベントビューアーで同じイベントを探す

PowerShellでWindowsのSystemログから直近イベントを読み、Event IDと時刻を手掛かりにイベントビューアーで同じ記録を探す読み取り専用教材です。

## 実行

```powershell
./observe-event.ps1
```

ログ削除・設定変更は行いません。環境によって表示されるEvent IDやProviderは異なります。

[Microsoft Learn — Get-WinEvent](https://learn.microsoft.com/powershell/module/microsoft.powershell.diagnostics/get-winevent)

検証状態: Microsoft公式仕様確認済み。Windows実機再確認は未実施。
