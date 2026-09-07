# ビットフラグをPowerShellで目で見る

`1 / 2 / 4` を8bitの2進数で表示し、`-bor` で組み合わせ、`-band` で個別フラグを判定する最小サンプルです。

## 観察ポイント

```text
Read    00000001
Write   00000010
Execute 00000100
```

異なるbitを使うため、ORで複数機能を1つの整数へ保持できます。

## 注意

`1 + 2 + 4 = 1 -bor 2 -bor 4` のように数値が同じになるのは、各値が重ならないbitを持つ場合です。一般に「足し算とORは同じ」と覚えないでください。

## 1か所変えてみる

`Read + Execute` から `Read + Write + Execute` へ変え、2進数と判定結果を比較します。

## 検証状態

PowerShell公式仕様の `-bor` / `-band` を確認して実装。このセッションには `pwsh` がないためPowerShell実行未確認です。

## 公式情報

- Microsoft Learn — PowerShell arithmetic / bitwise operators: https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_arithmetic_operators
