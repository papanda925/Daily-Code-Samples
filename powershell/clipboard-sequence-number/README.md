# クリップボード本文を読まず変更だけ検知する

Win32 `GetClipboardSequenceNumber` をPowerShellから呼び、クリップボード内容を保存・表示せず変更の有無だけを観察します。

- `Watch-ClipboardSequence.ps1` を実行します。
- 何かをコピーしてEnterを押し、sequence numberの前後差を見ます。
- 値が変わっても、誰が何をコピーしたかは分かりません。

検証状態: implemented / 実機未検証。

公式: https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-getclipboardsequencenumber
