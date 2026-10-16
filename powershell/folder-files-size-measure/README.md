# PowerShell：フォルダー直下のファイルサイズ合計

元記事：[Get-ChildItemとMeasure-Objectで容量を確認](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-05-body.md)。

このサンプルは、**指定フォルダー直下**の通常ファイルの論理サイズ（Length）を合計する読み取り専用ツールです。ファイルの削除・リネーム・移動・書込みはしません。

## まず試す

PowerShell 7でテスト用フォルダーを一つ作り、そこに任意の小さなテキストを保存する。次を実行（パスは自分の練習用に変更）。

```powershell
./Measure-FolderFiles.ps1 -Folder 'C:\Temp\FolderMeasureDemo'
```

**実機未実行の期待結果**：指定パス、対象ファイル数、合計バイト数、MiBへの換算値が表示される。0件なら0バイトが表示される。

## ここを見る

- `Get-ChildItem -LiteralPath` は角括弧などをワイルドカードとして解釈しない。
- `-File` はフォルダーではなく通常ファイルを対象にする。
- `Measure-Object -Property Length -Sum` はオブジェクトのLengthの合計を計算する。
- `1MB`というPowerShellの数値サフィックスは1,048,576バイト。結果名はMiB。
- デフォルトではサブフォルダー内と隠しファイルを集計しない。ディスクの割当サイズでもない。

## 1か所変える

フォルダーへ100バイトのファイルを追加し、TotalBytesが100増えたかを確かめる。サブフォルダーへ追加した場合は、このスクリプトの合計に含まれない。エラー時は不完全な合計を成功として扱わずに中断する。

## 仕事で使うなら

- ファイルが書き換えられる最中の値は変化する。監査値なら取得日時と静止条件が必要。
- 内容の正当性や削除可否は容量から判断できない。自動削除機能を追加しない。
- 共有ファイル名や内部パスを外部ログへ保存しない。

## 検証と一次資料

PowerShell 7向け。2026-10-16作成。Microsoft Learn：[Get-ChildItem](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-7.5)、[Measure-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/measure-object?view=powershell-7.5)。**PowerShell実機で未実行**、Windows PowerShell 5.1互換性は未検証。
