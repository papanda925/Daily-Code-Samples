# クリップボード本文を読まず変更だけ検知する

Win32 `GetClipboardSequenceNumber` をPowerShellから呼び、クリップボード内容を保存・表示せず変更の有無だけを観察します。

- `Watch-ClipboardSequence.ps1` を実行します。
- 何かをコピーしてEnterを押し、sequence numberの前後差を見ます。
- 値が変わっても、誰が何をコピーしたかは分かりません。

検証状態: implemented / 実機未検証。

公式: https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-getclipboardsequencenumber

## 実際の手順と期待結果

[Watch-ClipboardSequence.ps1](Watch-ClipboardSequence.ps1) はWin32 API `GetClipboardSequenceNumber()` を呼びます。Windows上のPowerShellで次を実行します。

```powershell
.\Watch-ClipboardSequence.ps1
```

`何かをコピーしてから Enter` が出たら、架空の短い文字列をコピーしてEnterを押します。**期待結果（未実行）**：変更が検出されると `[SUCCESS] Clipboard changed` と前後の番号を表示します。コピー操作が起こらなければ「変更を検出できませんでした」と表示する設計です。

## 安全・失敗時・検証

スクリプトはクリップボード本文を読みませんが、OS側の番号が変わったことだけを判定します。実機でのコピー操作やWindows APIの呼び出しは未検証です。起動できないときはWindows環境とPowerShellの実行ポリシーを確認してください。
