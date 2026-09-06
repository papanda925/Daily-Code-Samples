# Scripting.Dictionaryで重複件数を集計する

A列の値を大文字小文字を区別せず集計し、C列・D列へ「値 / 件数」を出力します。参照設定を追加せず `CreateObject("Scripting.Dictionary")` で使うLate Binding版です。

## 使い方

1. A2以降へ集計対象を入れます。
2. `DictionaryCount.bas` を標準モジュールへ貼ります。
3. `CountDuplicates` を実行します。

## 検証状態

Microsoft LearnのDictionary object仕様を確認して実装。Excel実機確認は未実施です。
