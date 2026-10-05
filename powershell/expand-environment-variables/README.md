# Environment.ExpandEnvironmentVariablesをPowerShellから試す

.NETの `Environment.ExpandEnvironmentVariables()` をPowerShellから呼び、`%SystemRoot%` や `%TEMP%` を文字列中で展開します。

## 実行

```powershell
./expand-env.ps1
```

## 観察ポイント

- 定義済み変数は値へ置換されます。
- 未定義の `%PAPANDA_NOT_SET%` はそのまま残ります。
- これは環境変数の値そのものを書き換える処理ではなく、入力文字列を展開して新しい文字列を返します。

## 検証状態

Microsoft Learnの.NET仕様を確認済みです。Windows/PowerShell実機確認は未実施です。
