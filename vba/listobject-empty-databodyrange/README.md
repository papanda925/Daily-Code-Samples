# Excelテーブルが空の場合にDataBodyRangeを安全に扱う

[元記事](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-03-body.md)。Excelテーブルのデータ行が0件でもマクロが停止しないようにする読取り専用サンプルです。

## まず試す

1. デスクトップ版Excelで新規ブックを作り「商品表」シートを作成。
2. A1=商品コード、B1=名称と入力し、A1:B1をテーブルにして名前を `tblProducts` にする。
3. `InspectProducts.bas` のコードを標準モジュールへ貼り、`InspectProducts`を実行。
4. 期待：0件なら「データ行なし」。A2=P101、B2=ノートを**テーブルのデータ行として追加した場合**には件数1、コードP101が出る。（Excel実機未実行）

## ここを見る

`ListRows.Count` はテーブルのデータ行数で、ワークシートの最終行とは別。`DataBodyRange` はテーブルの見出しを含まない領域で、空テーブルの場合にNothingとなることがある。Countを調べた後でもNothingを再確認してからセルへアクセスする。

## 1か所変える

テーブルのデータ行に空の数式を入れた場合と、行そのものを削除した場合を比較する。空文字が表示されていても、その行が存在すれば「0件」ではない。フィルターにより行を非表示にしても、行の件数が変わらない点も区別する。

## 仕事で使うなら

テーブルが空のときに「入力なし」は正常か、取込失敗かを業務仕様で決める。ヘッダー列名、表の名前、必須商品コードの有無をチェックする。フィルター後の可視行数を知りたいときは別の方法を使う。

## 検証状況

2026-10-16作成。Microsoft Learn [DataBodyRange](https://learn.microsoft.com/en-us/office/vba/api/excel.listobject.databodyrange) / [ListRows](https://learn.microsoft.com/en-us/office/vba/api/excel.listobject.listrows) / [Count](https://learn.microsoft.com/en-us/office/vba/api/excel.listrows.count) を参照。**Excel実機でのコンパイル・実行は未実施。** 元ブックの値は変更しない。
