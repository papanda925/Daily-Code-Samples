# .NETのFileSystemWatcherでフォルダ変更を監視する

PowerShellから `System.IO.FileSystemWatcher` を使い、作成・変更・削除・名前変更をイベントとして表示します。

## 実行例

`./Watch-Folder.ps1 -Path C:\Temp -Filter *.txt`

Ctrl+Cで終了します。

## 注意

FileSystemWatcherはOSの変更通知を使うため、短時間に大量の変更が起きると取りこぼしや重複通知を考慮する必要があります。厳密な監査ログ用途には別の仕組みを検討してください。

## 検証状態

Microsoft LearnのFileSystemWatcher仕様を確認して実装。PowerShell実機確認は未実施です。
