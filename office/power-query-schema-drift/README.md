# Power Query Mで列名ゆれを吸収する

「社員コード」「従業員ID」「社員ID」のように、月ごとに少し違う列名を標準名へ寄せ、必要列が欠けていても `null` で揃えるM関数です。

## 使い方

Power Queryの空のクエリを作り、`NormalizeColumns.pq` を関数として登録します。別クエリから `NormalizeColumns(Source)` のように呼びます。

## ポイント

- 最初に見つかった別名を標準名へ変更
- すでに標準名がある場合は変更しない
- 最終列は `MissingField.UseNull` で不足列をnull補完
- 列順も固定

## 検証状態

Power Query Mの `Table.RenameColumns`、`Table.SelectColumns`、`MissingField` 公式仕様を確認して実装。実データでの実行確認は未実施です。
