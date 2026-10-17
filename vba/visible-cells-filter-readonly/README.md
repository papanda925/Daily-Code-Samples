# フィルター後の表示行を読むVBA

元記事：[SpecialCells(xlCellTypeVisible)で見える行を数える](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-22/body.md)。

## まず試す

Windowsデスクトップ版Excelで新しいブックのシート名を「抽出練習」に変更し、A1にCode、B1に状態を用意。A2=P101/B2=有効、A3=P102/B3=停止、A4=P103/B4=有効を入力。A1:B4にオートフィルターを設定してB列が「有効」だけ表示されるようにする。標準モジュールへコードを貼って実行し、A2、A4、件数2を期待（未実行）。

## ここを見る

`SpecialCells(xlCellTypeVisible)`は表示セルを返す。値が空白の行や見出し行を含めたくないので、A2:A30というデータ範囲に限定して値のあるセルを数える。`On Error Resume Next`を狭い一行に限定し、捕捉した結果がNothingなら0件と判断する。

## 1か所変える

フィルターを「停止」に変え、表示がA3の1行になることを確かめる。さらに「該当なし」の状態を自分のダミーデータで用意し、結果が0件になることを確認。

## 仕事で使うなら

表示行数と、ワークシートに保存された全データ件数は異なる。抽出結果をCSVに書く場合、可視セルの飛び飛び範囲を一つの連続Rangeとして扱わない。ヘッダー、空欄、手動非表示を仕様として区別する。

## 公式情報・検証

[Microsoft Learn Range.SpecialCells](https://learn.microsoft.com/en-us/office/vba/api/excel.range.specialcells)。2026-10-17に仕様確認。Excel実機のマクロ実行は未実施。
