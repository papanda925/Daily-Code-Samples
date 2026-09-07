# Scripting.Dictionaryで重複件数を集計する

A列の値を大文字小文字を区別せず集計し、専用の「重複集計結果」シートへ「値 / 件数」を出力します。参照設定を追加せず `CreateObject("Scripting.Dictionary")` で使うLate Binding版です。

## 使い方

1. 入力用シートのA2以降へ集計対象を入れます。
2. `DictionaryCount.bas` を標準モジュールへ貼ります。
3. 入力用シートを選んだ状態で `CountDuplicates` を実行します。
4. 集計結果は「重複集計結果」シートへ出力されます。

## 安全側の変更

以前のサンプルは入力シートの `C:D` 列を丸ごと `ClearContents` していたため、既存データを消す可能性がありました。現在版は専用の結果シートだけをクリアして再利用します。

## ポイント

- `CreateObject("Scripting.Dictionary")` で参照設定を不要にする
- `CompareMode = vbTextCompare` で大文字小文字を同一視する
- 空白セルは数えない
- 入力データのあるシートを直接消去・変更しない

## 検証状態

Microsoft LearnのDictionary object仕様を確認して実装。Excel実機確認は未実施です。
