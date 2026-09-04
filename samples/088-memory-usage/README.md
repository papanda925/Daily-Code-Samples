# 088: メモリ使用量をアプリ起動前後で比較する

> **実験サンプル / 深掘り / 約10〜20分**

## このサンプルで体験すること
短い実験で「メモリ使用量をアプリ起動前後で比較する」を体験し、操作前後の状態やログの差を確認する。

**今の状態を見る → 1つ操作する → もう一度見る → 差分を確認する** を基本にします。

## 実行方法
1. `demo.ps1` を開いて内容を確認。
2. PowerShellは通常権限、VBAはテスト用Excelブックで実行。
3. 表示されたID・時刻・座標・状態等を記録。
4. 操作後に再実行して差を見る。

## 最小コード
```powershell
function M{$o=Get-CimInstance Win32_OperatingSystem;[pscustomobject]@{UsedGB=[math]::Round(($o.TotalVisibleMemorySize-$o.FreePhysicalMemory)/1MB,2);FreeGB=[math]::Round($o.FreePhysicalMemory/1MB,2)}}
"Before";M;Read-Host "アプリを起動してEnter";"After";M
```

## 見るポイント
- 操作前後で何が変わったか。
- Windowsが対象をID、Handle、状態、座標、アドレス等で管理していること。
- GUIとAPIで見える情報の層が異なる場合があること。

## 今回触っている技術の層
```text
PowerShell → CIM / WinRT / Windows API → Device / Driver
```

## 安全性
自分のPC・localhost・自分のネットワークで試します。管理者権限を前提にせず、他人の機器や許可されていないネットワークは対象にしません。

## 発展
GUI、PowerShell、VBAの別手段でも同じ状態を取得し、Win32 / .NET / WinRT / CIMの役割を比較してみてください。
