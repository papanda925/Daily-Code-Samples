# 2ファイルのSHA256比較（読み取り専用）

元記事：[Get-FileHashで同一内容を確認する](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-18/body.md)。SHA256の値を2つ計算し、内容が同じかを比較します。

## まず試す

PowerShell 7で `a.txt` と `b.txt` を練習用に用意し、両方へ同じ文字列を保存します。対象を自分で作ったファイルに限定してください。

```powershell
./Compare-FileHash.ps1 -First './a.txt' -Second './b.txt'
```

`SameContentHash=True` が想定結果です（実機未実行）。片方の1文字を変えて再実行するとFalseになる想定です。改行コードやBOMの違いもファイル内容の一部です。

## ここを見る

`Get-FileHash -LiteralPath` はワイルドカードを解釈せず、明示したファイルを読みます。`SHA256` はファイル内容からハッシュを計算する方式です。名前だけの一致では中身の一致を判定できません。

## 1か所変える

b.txtの末尾に改行を1つ追加して比較する。見た目には同じ文字列に見えても、バイト列が変わればハッシュも変わります。

## 仕事で使うなら

ダウンロード後の破損確認には配布元の信頼できるSHA256値が必要です。2ファイル同士の比較だけでは、双方が同じように改ざんされていないことを保証しません。ハッシュは秘密情報ではありませんが、パスやファイル名に内部情報を含めないでください。

## 公式情報・検証

[Microsoft Learn Get-FileHash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7.5)。2026-10-17仕様確認。スクリプトのPowerShell実機実行は未実施です。
