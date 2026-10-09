# Power Query M — Table.Schemaで列の構造を確認する

Power Queryに取り込むデータの列名・位置・型を確認し、必要な列が欠けていないかをチェックする3つのサンプルです。外部のCSVや認証は不要です。

## 使い方

`check-schema.pq` に入っている3つの独立した `let ... in ...` ブロックを、**それぞれ別の空クエリ**として実行します。ファイル全体を1つのクエリへ貼らないでください。

Excel: [データ] → [データの取得] → [その他のデータ ソースから] → [空のクエリ]（表示名はバージョンで変化する場合があります）→ Power Query エディターの [詳細エディター] に貼付けます。

Power BI Desktop: [データの変換] → [新しいソース] → [空のクエリ] → [詳細エディター]。

## 期待値

1. **Query 1:** Name/Position/TypeName/Kind/IsNullableを持つ3行のスキーマ情報。Positionは0, 1, 2。型名の文字列表記はコネクタ/型により異なり得ます。
2. **Query 2:** 必須列 `Amount` が存在しないため、「Required column(s) missing: Amount」というエラーで中止。
3. **Query 3:** `OrderId + Amount` が `true`、`OrderId + Owner` が `false` の2行。

## 注意

- `Table.Schema` は **列のメタデータ** を見る関数です。全レコードの内容品質や型変換の成功を証明するものではありません。
- `Table.HasColumns` は **列の有無のみ**を返します。列の値や型を検証しません。
- データソース側で列構造が変化する場合、更新前に列の存在確認を入れることができます。
- コードはMicrosoftの公式仕様に沿って構成しましたが、Power Query実機での実行確認はまだ行っていません。実行結果は期待値です。

## 一次情報

- [Microsoft Learn: Table.Schema](https://learn.microsoft.com/en-us/powerquery-m/table-schema)
- [Microsoft Learn: Table.ColumnNames](https://learn.microsoft.com/en-us/powerquery-m/table-columnnames)
- [Microsoft Learn: Table.HasColumns](https://learn.microsoft.com/en-us/powerquery-m/table-hascolumns)
- [Microsoft Learn: Table.FromRows](https://learn.microsoft.com/en-us/powerquery-m/table-fromrows)
- [Microsoft Learn: List.Difference](https://learn.microsoft.com/en-us/powerquery-m/list-difference)
