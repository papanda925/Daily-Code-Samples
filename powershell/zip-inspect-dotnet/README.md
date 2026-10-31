# .NETのZipFileでZIPを展開せず調べる

PowerShellから `System.IO.Compression.ZipFile` を直接使い、ZIPを展開せずにファイル名、元サイズ、圧縮後サイズを一覧表示します。

## 実行例

`./Inspect-Zip.ps1 -Path ./sample.zip`

## 検証状態

Microsoft LearnのZipFile / ZipArchive API仕様を確認して実装。PowerShell実機確認は未実施です。

## まず試す

[Inspect-Zip.ps1](Inspect-Zip.ps1) は `System.IO.Compression.ZipFile.OpenRead` でZIPの一覧を取得し、**展開せずに**ファイル名・サイズ・圧縮サイズ・日時・件数を表示します。

PowerShellで練習用フォルダーに小さなZIPを作ります。

```powershell
Set-Content -LiteralPath .\sample.txt -Value 'sample'
Compress-Archive -LiteralPath .\sample.txt -DestinationPath .\demo.zip
.\Inspect-Zip.ps1 -Path .\demo.zip
```

**期待結果（未実行）**：`sample.txt` の一覧と `FileCount=1` が表示される想定です。処理後は `finally` でアーカイブを閉じます。

## うまく動かないとき・制限

ZIPがない・破損している・権限不足の場合は例外になります。**内部エントリ名が安全であることを保証する検査ではありません**。展開や危険パスの審査が必要なら別途行ってください。既存`demo.zip`を上書きしないよう練習用フォルダーを使います。

## 検証

2026-10-31：コードの読取りによる説明のみ。PowerShellの実行・ZIPの実解析は未実施。公式：[ZipFile.OpenRead](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression.zipfile.openread)。
