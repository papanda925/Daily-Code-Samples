# Office Scriptsでテーブル内の文字列を整える

Excelテーブル内の文字列だけを対象に、前後空白、全角スペース、連続空白を整えます。

数式セルは書き換えません。

## 使い方

1. 対象範囲をExcelテーブルにします。
2. Office Scriptsへ `main.ts` を貼り付けます。
3. 実行前にバックアップを取ります。
4. 最初のテーブルを対象に文字列を正規化します。

## 検証状態

Microsoft LearnのOffice Scripts Range API仕様を確認して実装。対象Microsoft 365環境での実機確認は未実施です。
