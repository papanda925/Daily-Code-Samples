# PowerShell + WPF + FileSystemWatcherで変更イベントを観察する

ダミーフォルダだけを監視し、`FileSystemWatcher` が受け取った変更イベントをWPF画面へ渡す教材です。

> 状態: implemented / Windows実機での実行確認は未実施

## まず試す

通常権限のWindows PowerShellで実行します。

```powershell
.\Show-FileEvents.ps1
```

スクリプトはユーザーのTEMP配下に専用ダミーフォルダを作り、そのフォルダだけを監視します。本番フォルダを既定値にしません。

画面が開いたら「テストファイルを作る」を押します。イベント欄に `Created` / `Changed` 等が表示されればSmoke Test成功です。

## ここを見る

`FileSystemWatcher` のイベントハンドラーからWPFコントロールを直接更新せず、イベントをキューへ積み、UI側の`DispatcherTimer`が取り出して表示します。

```text
FileSystemWatcher -> ConcurrentQueue -> DispatcherTimer -> WPF ListBox
```

これにより「ファイルイベントが来る場所」と「UIを更新する場所」を分離して観察できます。

## 1か所変える

`Filter` の既定値は `*.txt` です。

```powershell
.\Show-FileEvents.ps1 -Filter '*.csv'
```

同じダミーフォルダでも、監視対象拡張子を変えると表示されるイベントがどう変わるか確認できます。

## なぜイベントが複数回来ることがあるのか

1回の保存操作でも、アプリ側が一時ファイル作成、書き込み、rename等を複数回行うことがあります。`Changed`が1操作につき必ず1回だけ来るとは考えないことが重要です。

実務版へ育てる場合はdebounce、重複抑制、対象ファイルの安定待ちなどを追加します。

## 仕事で使うなら

- CSV受信フォルダの到着状況をローカル画面で観察する
- バッチ処理前に「ファイルが来た」ことだけを通知する
- 設定ファイル変更をトラブルシュート時に観察する
- FileSystemWatcherを使う社内ツールのイベント学習用にする

このサンプル自体はファイルを自動処理しません。まずイベントの挙動を理解するための教材です。

## 後始末

画面を閉じると、`EnableRaisingEvents = false`、`Dispose()`、DispatcherTimer停止を行います。イベント監視を残したままにしないためです。

## ファイル

- `Show-FileEvents.ps1` — ダミーフォルダ限定のWPFイベントビューア

## 検証状態

.NET / WPF / FileSystemWatcher仕様を基に実装していますが、追加時点ではWindows実機実行証拠がないため `tested` ではありません。
