# Excel HSTACK / VSTACK の不足行・不足列を観察する

Microsoft 365 Excel / Excel 2024系で利用可能な動的配列関数です。古いExcelでは利用できません。

1. A1:B4に2列×4行の表（ヘッダー込み）を作成。例：氏名・部門、3データ行。
2. D1:F3に3列×3行の表（ヘッダー込み）を作成。例：コード・数量・価格、2データ行。
3. `formulas.txt` の式を元表と重ならない場所に入力。
4. HSTACKは3行×5列、VSTACKは5行×3列を返す想定。不足部分の`#N/A`に注目。
5. IFNAで見た目を空に変えた後でも、空になった値と元データのエラーは区別できない点に注意。

元データのセルは変更しません。式が広がる先に値があると`#SPILL!`になる可能性があります。

**検証：Microsoft公式仕様のみ。Excel実機未検証。**

- https://support.microsoft.com/en-us/excel/functions/hstack-function
- https://support.microsoft.com/en-us/excel/functions/vstack-function
