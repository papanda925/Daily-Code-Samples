# Tests

このフォルダには、Daily Codeのサンプルが想定どおり動くか確認するためのテストを置きます。

## Sample 001

`Test-001-FileHash.ps1` は次を確認します。

1. コピーしたファイルは同じHashになる
2. 中身を変更するとHashが変わる
3. ファイル名だけ変更してもHashは変わらない

手元では次のように実行できます。

```powershell
.\tests\Test-001-FileHash.ps1
```

また、GitHub ActionsでもWindows PowerShell 5.1とPowerShell 7の両方で自動テストします。

## 方針

利用者向けREADMEの「自分で試すテスト」と、自動化された回帰テストは役割を分けます。

- README: 初心者が結果を見ながら理解するため
- tests/: コード変更で以前の動作を壊していないか確認するため
