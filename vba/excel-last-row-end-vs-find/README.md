# Excel VBA：End(xlUp)とFindの最終行比較

Excel VBAで「A列の最後」と「シート全体の最後」を混同しないための、**読取り専用**の教材です。元データの変更・保存は行いません。

関連記事: [Excel VBAの最終行はどこ？](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-01-body.md)

## まず試す

1. Windowsのデスクトップ版Excelで新規ブックを作成し、シート名を「検証用」にする。Web版ExcelではVBAを実行できない。
2. A1=商品コード、A2=P101、A5=P103、B8=備考、C12には数式 `=""` を入力する。値がある場所を誤らないよう、他のセルは空にする。
3. `CompareLastRowMethods.bas` のコードをAlt+F11→挿入→標準モジュールへ貼り付ける。Ctrl+Gでイミディエイトを開き `CompareLastRowMethods` を実行する。
4. 想定：A列は5、数式を含むシート末尾は12、値で見た末尾は8（**Excel実機未実行の期待値**）。

## ここを見る

- `End(xlUp)` はA列だけの境界を返す。シート全体の最終行とは限らない。
- `Find(What:="*", LookIn:=xlFormulas)` は空文字を返す式自体も数式として検索する。
- `LookIn:=xlValues` では表示値を基準にする。戻り値がNothingのときの分岐を確認する。
- A列が完全に空なら `End(xlUp).Row=1` の場合があっても「データが1件」と解釈しない。

## 1か所変える

C12の `=""` を削除して、数式を含む検索結果の最終行が8になるかを観察する。次にB8を削除するとA列の最終行とシート全体の最終行が一致する想定。データ変更は練習用のシートのみで行う。

## 仕事で使うなら

- キー列が必須なら列限定の最終行が有用。脚注や別列の入力があるなら全体検索は過大計上になる場合がある。
- 空欄やフィルター、テーブル、結合セルのある本番帳票では最終行の定義を仕様化する。
- 検証用コードはブックを更新しない。実務へ組み込む前にはExcel版、マクロ設定、空シート・見出しのみなども試す。

## 検証状態

2026-10-16作成。Microsoft公式の [Range.End](https://learn.microsoft.com/en-us/office/vba/api/excel.range.end) / [Range.Find](https://learn.microsoft.com/en-us/office/vba/api/excel.range.find) を参照。**VBAコンパイルとExcel実機試験は未実施。** GitHub Actionsの成功だけでは実機確認済みとはみなさない。
