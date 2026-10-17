# FindNextで全一致を列挙（値を書き換えない）

元記事：[Excel VBA FindNextの折り返しと終了条件](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-21/body.md)。

## まず試す

Excelデスクトップ版の練習用ブックへ「検索練習」シートを作り、A2=P101、A3=P102、A4=P101、A5=P103と入力。標準モジュールへ`List-AllMatches.bas`の内容を貼り、`ListMatchingCells`を実行。A2とA4、計2件が出ることを期待（未実行）。

## ここを見る

`Range.Find`は最初の一致セルを返し、該当なしならNothing。`FindNext`は最後まで行くと最初へ折り返すため、最初に取得したアドレスを保持し、一周したらループを止める。検索ダイアログと一部検索条件が共用されるため、LookIn・LookAt・SearchOrder等を明示している。

## 1か所変える

A4をP104に変更すると1件へ、A2もP104に変えると0件へ減ることが期待される。データの変更は読者が練習用セルで行い、掲載マクロは読取りのみ。

## 仕事で使うなら

重複禁止のキーを検索する場合、1件見つかって終わらせると重複を見逃す。最後まで数えたうえで件数が2件以上なら警告する。大量行の場合は検索範囲を現実のデータに合わせて限定する。

## 公式情報・検証

[Microsoft Learn Range.Find](https://learn.microsoft.com/en-us/office/vba/api/excel.range.find)、[Range.FindNext](https://learn.microsoft.com/en-us/office/vba/api/excel.range.findnext)。2026-10-17仕様確認。VBAコンパイルとExcel実機実行は未実施。
