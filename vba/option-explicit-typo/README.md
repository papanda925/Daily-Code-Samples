# VBA Option Explicit

変数名の打ち間違いを、実行後ではなくcompile時に見つける教材です。

## 試し方
1. `OptionExplicitDemo.bas` をVBEへimportするか、内容を標準moduleへ貼り付けます。
2. そのまま `Demo` を実行すると `total=10` を出力します。
3. `totla = total + 5` のコメントを外し、Debug > Compile を実行します。
4. 未宣言変数として検出されることを確認します。

既存bookのcellやfileは変更しません。

Microsoft Learn: https://learn.microsoft.com/office/vba/language/reference/user-interface-help/option-explicit-statement

検証: 公式仕様確認済み。Excel/VBE実機再実行未実施。
