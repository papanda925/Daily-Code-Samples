# PowerShell + XAML: UIを固めずバックグラウンド処理を待つ

WPFのUIスレッドを `Start-Sleep` などで直接止めず、別の PowerShell 実行パイプラインを `BeginInvoke()` で開始し、`DispatcherTimer` で完了を観察する最小教材です。

## 何を確認するサンプルか

1. ボタンを押すとバックグラウンド側で3秒待機を開始します。
2. 待機中もWPFのウィンドウはドラッグできます。
3. `DispatcherTimer` が `IsCompleted` を確認し、完了後だけ `EndInvoke()` で結果を取得します。
4. 最後に PowerShell オブジェクトを `Dispose()` します。

これは「重い処理は何でもUIスレッドから追い出せばよい」という万能例ではありません。WPFコントロールは作成したUIスレッドに紐づくため、バックグラウンド側から直接書き換えず、UI更新はDispatcher側へ戻して行います。

## 実行

Windows PowerShell 5.1 または WPFを利用できるWindows上のPowerShellで、次を実行します。

```powershell
.\Show-AsyncWpfDemo.ps1
```

## 観察ポイント

- `[START]` が表示された後、3秒間ウィンドウを動かせるか
- 完了時に `[SUCCESS]` と結果が表示されるか
- 閉じる操作で未完了処理を停止・破棄できるか

## 検証状態

Microsoft Learn の WPF threading model と `Dispatcher` の説明に照合して作成しています。実Windows環境での実行証拠はまだ記録していないため、`tested` ではありません。

## 公式情報

- Microsoft Learn — WPF Threading Model: https://learn.microsoft.com/dotnet/desktop/wpf/advanced/threading-model
- Microsoft Learn — PowerShell.BeginInvoke: https://learn.microsoft.com/dotnet/api/system.management.automation.powershell.begininvoke
