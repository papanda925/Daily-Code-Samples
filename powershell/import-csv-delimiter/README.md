# Import-Csvで区切り文字を観察する

## まず試す
`Show-CsvShape.ps1` はTEMPへダミーCSVを作り、指定した区切り文字で読み込みます。

## ここを見る
`PropertyNames` と `PropertyCount` を確認します。想定2列なら2になれば成功です。

## 1か所変える
`-Delimiter ';'` を `-Delimiter ','` に変え、同じファイルの列解釈が変わることを観察します。

## 仕事で使うなら
外部CSVの受入確認、Excel/Power Queryへ渡す前の列構造チェックに使えます。

## 注意点
ダミーデータのみを既定値にし、本番ファイルは上書きしません。実装済み・PowerShell実機未確認です。
