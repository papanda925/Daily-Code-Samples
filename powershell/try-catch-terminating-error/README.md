# PowerShell try/catch と terminating error

`-ErrorAction Stop` を使い、cmdletの失敗を `catch` へ渡す最小教材です。

## 実行

```powershell
./demo.ps1
./demo.ps1 -Path ./README.md
```

存在しないpathでは `FAILED`、存在するfileでは `SUCCESS` を観察します。実在fileを変更・削除しません。

## 確認点
- terminating errorだけがcatchへ移る
- finallyは成功/失敗の両方で実行される
- error messageを観察できる

Microsoft Learn: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_try_catch_finally

検証: 公式仕様確認済み。実機再実行未実施。
