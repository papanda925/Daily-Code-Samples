# PowerShellで2つのファイルのSHA-256を比較する

papanda925.com の記事で使うコード／コマンドを、再利用しやすい形で保存したサンプルです。

- 元記事ID: `20260906-03`
- 分類: `powershell`
- 検証状態: 記事制作時の構文・ロジック確認を引き継ぎます。実機実行を確認していない場合は、利用環境で確認してください。

## ファイル

- `Compare-FileHash.ps1` — 記事で扱ったコード／コマンドの再利用版

## 使い方

ファイル内容と前提条件を確認し、ダミー値・安全な対象で試してください。

> 秘密情報、実環境のドメイン、アクセストークンなどはサンプルへ保存しません。

## 手元で試す

Windows PowerShell 5.1 または PowerShell 7 で、別の練習用フォルダーへ [Compare-FileHash.ps1](Compare-FileHash.ps1) を保存します。元ファイルを触らないため、同じフォルダーにダミーを用意します。

```powershell
Set-Content -LiteralPath .\fileA.txt -Value 'sample'
Set-Content -LiteralPath .\fileB.txt -Value 'sample'
.\Compare-FileHash.ps1
```

**期待結果**：`Same` が `True`。次に `Set-Content -LiteralPath .\fileB.txt -Value 'changed'` として再実行すると、`Same` は `False` の想定です。ファイル名は固定なので業務ファイルのある場所で実行しないでください。

## 仕組みとエラーの見方

`Test-Path -LiteralPath -PathType Leaf` で存在確認後、`Get-FileHash -Algorithm SHA256` の値を比較します。見つからない場合は例外で停止します。入力の内容やパスに関する安全確認が必要です。`Same=True` は同一のSHA-256値を示し、内容の完全な安全性を保証するものではありません。

## 検証状態

2026-10-31：コードを読んで手順と期待結果を照合。PowerShell実行・実ファイルでの試験は未実施。公式：[Get-FileHash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash)。
