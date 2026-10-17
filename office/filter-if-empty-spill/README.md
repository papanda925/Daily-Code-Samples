# FILTERの該当なしとスピル失敗を分けるExcel教材

元記事：[Excel FILTERで該当なしと#SPILL!を区別](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-23/body.md)。

## まず試す

Excel for Microsoft 365 / Excel 2021・2024のFILTER対応環境で、新規シートへ架空の商品データ4行を入力。`formulas.txt`のF2の式を貼り、E2を「文具」にすると該当2行がF2:H3へ広がる想定（実機未実行）。出力範囲は空にしておく。

## ここを見る

`FILTER(array,include,[if_empty])`の第三引数は対象0件の場合の表示。`#SPILL!`は出力先に展開できない別種のエラーで、0件とは意味が異なる。`#CALC!`も第三引数を省略した0件で生じ得る。

## 1か所変える

E2を「衣料」にして「該当なし」が出る想定。その後G2にダミー値を入れてE2を文具に戻すと、スピル先が埋まっているため#SPILL!となるか確認。元データを失わないため練習用の新規ブックを使用。

## 仕事で使うなら

FILTERの戻り値は動的に行数が変わる。出力範囲の下に別の表を置くと更新時にスピルが衝突する。Excelテーブル内でスピルできない場合もあるので、出力セルの位置や対象環境を設計する。

## 出典・検証状態

[Microsoft Support FILTER関数](https://support.microsoft.com/en-us/excel/functions/filter-function)。2026-10-17仕様確認。Excel実機での数式評価は未実施。
