# VBA Application.Matchで商品コードを照合し、IsErrorで未検出を分ける

元記事：[Matchで見つからないとき](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-02-body.md)。このサンプルは、入力キーの存在確認と、検索範囲内の相対位置を正しく扱うための読取り専用コードです。

## まず試す

Windowsデスクトップ版Excelで新しいブックを作成し、シート「商品表」のA1に商品コード、A2=P101、A3=P102、A4=P103を入力する。Alt+F11の標準モジュールへ`MatchProductCode.bas`の内容を貼り付け、`FindProductCodeDemo`を実行する。結果はCtrl+Gのイミディエイトに表示される。マクロ無効のWeb版Excelでは実行できない。

期待例（実機未実行）：
- P102：検索範囲で2番目、シート上ではA3
- P999：見つからないと表示
- P101：検索範囲で1番目、A2

## ここを見る

`Application.Match`の結果はVariantで受け取り、数値へ変換する前に`IsError`で確認する。見つからない場合はExcelのエラー値が返り得るため、先にLongに代入するコードは避ける。第三引数`0`は完全一致を示し、近似一致による誤照合を防ぐ。

## 1か所変える

`FindOneCode "P102"` の引数を `"P999"` に変更して不一致の分岐を確認する。A4をP102へ変更すると二件存在するが、この例のMatchは最初の位置を返す。重複候補がある場合は自動的に一件を正として採用せず警告する。

## 仕事で使うなら

キー列のデータ型を統一し、先頭ゼロ、空欄、前後の空白、重複を検査する。検索の成功は商品コードが現れるという意味であり、取引許可や現行商品の確認とは別。メッセージには実際のシート上のアドレスを示す。

## 注意点・検証

実ファイルを変更せず、サンプルは`ThisWorkbook`内だけを参照する。Microsoft公式 [Match](https://learn.microsoft.com/en-us/office/vba/api/excel.worksheetfunction.match) / [IsError](https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/iserror-function) を参考。2026-10-16作成。**Excelコンパイル・実機実行未確認。**
