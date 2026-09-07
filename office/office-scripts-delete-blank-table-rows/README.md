# Office Scriptsでテーブルの完全空白行を削除する

指定したExcelテーブルを対象に、**全セルが空白のデータ行だけ**を下から順に削除します。ブック内のテーブルが1つだけなら、テーブル名は省略できます。

## 使い方

1. Excelの対象範囲をテーブル化します。
2. Office Scriptsの新しいスクリプトへ `main.ts` の内容を貼り付けます。
3. 実行前に対象ブックのバックアップを取ります。
4. テーブルが複数ある場合は、実行画面の `tableName` に対象名を入力します。
5. 実行すると削除件数をログへ表示します。

## 安全側の設計

- ワークシート全体の行ではなく、テーブルのデータ行だけを削除します。
- 下から上へ削除し、行番号のずれを避けます。
- テーブルがない場合は処理を止めます。
- **複数テーブルがある場合、先頭テーブルを勝手に選ばず `tableName` の指定を求めます。**

Office Scriptsは `main` 関数へ追加パラメーターを定義でき、オプションパラメーターも利用できます。その仕組みを使って対象表を明示できるようにしています。

## 検証状態

Microsoft LearnのOffice Scripts Table APIとmainパラメーター仕様を確認して実装。対象Microsoft 365環境での実行確認は未実施です。

## 公式情報

- [Microsoft Learn — Get user input for scripts](https://learn.microsoft.com/en-us/office/dev/scripts/develop/user-input)
- [Microsoft Learn — ExcelScript.Table](https://learn.microsoft.com/en-us/javascript/api/office-scripts/excelscript/excelscript.table?view=office-scripts)
