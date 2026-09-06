# .NETのZipFileでZIPを展開せず調べる

PowerShellから `System.IO.Compression.ZipFile` を直接使い、ZIPを展開せずにファイル名、元サイズ、圧縮後サイズを一覧表示します。

## 実行例

`./Inspect-Zip.ps1 -Path ./sample.zip`

## 検証状態

Microsoft LearnのZipFile / ZipArchive API仕様を確認して実装。PowerShell実機確認は未実施です。
