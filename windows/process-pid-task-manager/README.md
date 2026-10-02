# Get-ProcessのPIDをタスクマネージャーで答え合わせ

PowerShellで取得したプロセスID（PID）を、Windowsのタスクマネージャー「詳細」タブで確認する読み取り専用教材です。

## 実行

```powershell
./observe-process.ps1
```

自分自身のPowerShellプロセスと、実行中プロセスの一部を表示します。プロセスの停止・設定変更は行いません。

## 観察ポイント

1. PowerShellの `Id` がPIDです。
2. タスクマネージャーを開き「詳細」タブのPID列を確認します。
3. 同じPIDを探し、コンソールとGUIが同じOS状態を別の入口から見ていることを確認します。

[Microsoft Learn — Get-Process](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-process)

検証状態: Microsoft公式仕様確認済み。Windows実機再確認は未実施。
