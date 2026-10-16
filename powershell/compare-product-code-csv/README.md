# PowerShellでCSVの商品コード差分を検査する

元記事：[2つのCSVで追加・削除された商品コードを調べる](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-06-body.md)。

PowerShell 7を想定した読み取り専用サンプル。CSVのCode列をキーとして、前月にはない「追加」と今月にはない「削除」を比較します。Nameや価格の変更検出は目的に含みません。**入力が空、コード重複、必須列欠落なら集計を続けません。**

## まず試す

UTF-8の2ファイルを練習用に作る。before.csvは `Code,Name` の見出しの下に `A001,鉛筆`、`A002,消しゴム`、`A003,ノート`。after.csvは `A001,鉛筆`、`A003,ノート`、`A004,定規` を入れる。

PowerShell 7で（実パスは自分の練習用に変更）：

```powershell
./Compare-ProductCsv.ps1 -Before './before.csv' -After './after.csv'
```

期待値（**未実行**）：A002が「削除」、A004が「追加」。記事の短い例と違い、サンプルでは不足列・空欄・重複を先に検査し、結果を再利用しやすいオブジェクトとして返します。

## ここを見る

- `Import-Csv` はヘッダー行をプロパティ名として各行を読み込む。CSVが空ならエラーにする。
- `Compare-Object` は参照側（Before）と比較側（After）を比較する。`<=` が削除、`=>` が追加の意味。
- データに重複がある場合、単純に重複を捨てると件数異常を隠すため、このサンプルは停止する。
- 大文字小文字を区別しない商品コード前提。大小文字が別IDを指すなら設計を変更する。
- 先頭ゼロは数値化しないため保持される。ExcelでCSVを開いて再保存する際は自動型変換に注意。

## 1か所変える

after.csvのA004をA002に変更すると、追加・削除0件となる想定。次にafter.csvへA002を二行追加すると、重複が検出されて停止する想定。業務判断上、無条件に重複を一件へまとめないことが大切。

## 仕事で使うなら

入力元の文字コードを必ず確認する。受領CSVがShift_JISなのにUTF-8として読むと日本語が壊れる可能性がある。ファイル名・結果に個人情報や内部識別子が含まれる場合、ログを外部公開しない。エラー時に「変更なし」と表示せず、再取込の必要性を伝える。

## 検証・出典

2026-10-16作成。Microsoft Learn [Import-Csv](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-csv)、[Compare-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/compare-object)、[Sort-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object)を参考。**PowerShell実機未実行。** GitHub Actionsのパーサー合格は実機での出力確認と区別する。
