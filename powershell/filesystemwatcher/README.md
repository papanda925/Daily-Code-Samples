# .NETのFileSystemWatcherでフォルダ変更を監視する

PowerShellから `System.IO.FileSystemWatcher` を使い、作成・変更・削除・名前変更をイベントとして表示します。

## 実行例

`./Watch-Folder.ps1 -Path C:\Temp -Filter *.txt`

Ctrl+Cで終了します。

## 注意

FileSystemWatcherはOSの変更通知を使うため、短時間に大量の変更が起きると取りこぼしや重複通知を考慮する必要があります。厳密な監査ログ用途には別の仕組みを検討してください。

## 検証状態

Microsoft LearnのFileSystemWatcher仕様を確認して実装。PowerShell実機確認は未実施です。

## まず試す

[Watch-Folder.ps1](Watch-Folder.ps1) は指定したフォルダー直下のファイル変更イベントを表示します。Windows PowerShell / PowerShellで練習用フォルダーを作り、監視を始めます。

```powershell
New-Item -ItemType Directory -Path .\watch-demo -ErrorAction SilentlyContinue
.\Watch-Folder.ps1 -Path .\watch-demo -Filter '*.txt'
```

別ウィンドウから練習用フォルダーへtxtファイルを作成・更新すると、`Created` / `Changed` などのイベントが表示される想定です。

## ここを見る・動かないとき

`IncludeSubdirectories=$false` なので配下フォルダーは対象外です。イベントが複数発生する場合や取りこぼす場合もあり、正確な監査証跡の代わりにはなりません。監視が始まらないときは対象の実在・権限・Filterを確認します。終了はCtrl+Cです。

## 検証

2026-10-31：PowerShellのソースを照合。実OSイベントの受信は未検証。業務データは監視対象にしないでください。
