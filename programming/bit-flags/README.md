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


## 要求マスクの再利用版

`Test-FlagMask.ps1`は、0〜7の教材用マスクを受け取り、Any／Allを比較します。
ファイル・ネットワーク・実権限を変更しません。管理者権限不要です。

### まず試す

```powershell
./Test-FlagMask.ps1 -Flags 5 -Required 3
```

### ここを見る

CommonBits=1、HasAny=True、HasAll=Falseが期待値です。
OrDuplicate=1とAddDuplicate=2を比較すると、足し算をORの代用にできない理由が見えます。

### 1か所変える

Flagsを7へ変えるとHasAll=Trueが期待値です。
Flags=0ならRequired=3に対してAny／AllともFalse。
Required=0ならAny=False、All=Trueです。「何も要求しない」を認めるか業務側で決めます。
Flags=8や-1はValidateRangeで拒否します。

### 仕事で使うなら

この例の数値は教材用です。実APIの定数へ流用せず、
単独フラグか複合マスクか、整数型・ビット幅・未知ビットの扱いを確認してください。
実権限チェックには、対象システムの認証・認可APIを使います。

### 検証範囲

2026-10-01、Microsoft LearnのOR／AND／NOTを照合。
PowerShellランタイムがないため、追加コードのPowerShell実行・構文解析は未実施。
期待値を実測出力とは表示しません。

- [Microsoft Learn — PowerShell演算子](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arithmetic_operators)
