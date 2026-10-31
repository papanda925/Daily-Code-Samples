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

## 具体的な結果と切り分け

[OptionExplicitDemo.bas](OptionExplicitDemo.bas) は `Option Explicit` を先頭に書き、変数 `total` を宣言しています。

1. VBAの標準モジュールに取り込み、`Demo` を実行します。**期待結果（未実行）**：イミディエイトウィンドウへ `total=10` と表示されます。
2. コード内の `' totla = total + 5` の行から先頭のコメント記号を外します。
3. VBAのコンパイルを実行すると、`totla` は未宣言なのでエラーになる見込みです。

## なぜ役立つか・注意

`Option Explicit` は変数名のタイプミスを早く検出するためのもので、型・処理全体の正しさを保証しません。実務ブックで試さず、必ず練習用の新しいブックを使ってください。2026-10-31：GitHubのVBAソースを照合。実機Excel/VBEのコンパイル・実行は未検証。
