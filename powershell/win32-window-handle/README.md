# PowerShellからHWNDを観察する

画面を持つプロセスの `MainWindowHandle` を読み取り、Win32のウィンドウ識別子(HWND)を観察する最小教材です。

## まず試す

`Show-MainWindowHandle.ps1` を実行します。ウィンドウを持つプロセスだけを表示し、他アプリは操作しません。

## ここを見る

ProcessName、Id、MainWindowTitle、HWND(decimal/hex)を対応付けます。

## 1か所変える

メモ帳など自分で起動したアプリを1つ増やして再実行し、一覧へ新しいHWNDが現れるか確認します。

## 仕事で使うなら

GUI自動化やWin32 APIを学ぶ前に、ProcessとWindowが同じ概念ではないことを観察できます。

## 注意点

HWNDは永続IDとして保存しないでください。プロセスやウィンドウの状態で変わり得ます。このサンプルはread-onlyです。

検証状態: implemented。Windows実機では未確認です。
