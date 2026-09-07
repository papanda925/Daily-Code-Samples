# PowerShell + XAMLで最小GUIを作る

XAMLで画面構造を定義し、PowerShell側でButtonのClickイベントを受ける最小WPFサンプルです。見た目を作り込む前に「XAMLからPowerShellへイベントが届く」ことだけをSmoke Testします。

## 今回の成功条件

1. ウィンドウが表示される
2. TextBoxへ文字を入力する
3. Buttonを押す
4. 画面とコンソールの両方に `[SUCCESS]` / `[RESULT]` が出る

この4点が確認できれば成功です。

## 実行

Windows PowerShell 5.1 でSTAを明示して実行します。

```powershell
powershell.exe -STA -ExecutionPolicy Bypass -File .\Show-MinimalXamlWindow.ps1
```

## ここを見る

- XAMLはUI要素を定義する
- `FindName()` でPowerShell側から名前付き要素を取得する
- `Add_Click()` でPowerShellの処理をイベントへ接続する
- `ShowDialog()` 中はUIのイベントループで操作を受け付ける

## 1か所変えてみる

Buttonの `Content` だけ変える、またはTextBlockを1つ増やして結果表示先を分けてみます。

## 次の段階

Smoke Testが動いた後なら、Grid、色、余白、ステータス表示などを足して「PowerShellなのに見栄えのする画面」へ育てられます。最初から装飾を増やさないのは、XAMLの問題とイベント配線の問題を切り分けやすくするためです。

## 検証状態

Microsoft LearnのWPF/XAML/Dispatcher資料を確認して実装。このセッションにはWindows環境がないため実機未確認です。

## 公式情報

- Microsoft Learn — XAML overview: https://learn.microsoft.com/en-us/dotnet/desktop/wpf/xaml/
- Microsoft Learn — WPF threading model: https://learn.microsoft.com/en-us/dotnet/desktop/wpf/advanced/threading-model
