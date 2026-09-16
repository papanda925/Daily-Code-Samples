# PowerShellでWindowsの最終入力からIdle時間を観察する

Win32 API `GetLastInputInfo` をPowerShellからP/Invokeし、現在のWindowsセッションで最後にキーボード/マウス入力が行われてからの経過時間を観察する教材です。

> 状態: implemented / Windows実機での実行確認は未実施

## まず試す

`Get-InputIdle.ps1` を保存し、通常権限のPowerShellで実行します。

```powershell
.\Get-InputIdle.ps1
```

成功時は次のような形で値を表示します。

```text
[SUCCESS] IdleSeconds = 12.4
```

## ここを見る

数秒間マウスとキーボードに触れずに再実行し、`IdleSeconds` が増えるか確認します。その後マウスを動かして再実行し、小さい値へ戻るか観察します。

この値は「最後の入力からの経過時間」であり、勤怠、在席、作業時間、本人確認を意味しません。

## 1か所変える

分単位でも見たい場合は次のようにします。

```powershell
.\Get-InputIdle.ps1 -Unit Minutes
```

`Seconds` と `Minutes` の表示だけを変えて、取得している元データは同じであることを確認してください。

## 仕事で使うなら

自分用PCで、一定時間入力がないときだけローカルの重い集計を始める、デモ端末の状態表示を切り替える、といった補助条件に利用できます。

従業員監視、勤怠判定、評価には使わないでください。`GetLastInputInfo` はその目的の証拠を提供するAPIではありません。

## 安全性

- 管理者権限は不要です。
- ファイルや設定を変更しません。
- 入力内容そのものは取得しません。
- 実行中のWindowsセッションの情報として扱います。

## ファイル

- `Get-InputIdle.ps1` — 再利用しやすいパラメータ付きサンプル

## 検証状態

Microsoft Win32 API仕様を基に実装していますが、このリポジトリへの追加時点ではWindows実機実行証拠がないため `tested` ではありません。
