# 固定長テキストを16進ダンプで観察する

架空データだけで固定長レコードを作り、PowerShellの Format-Hex でbyte offset、空白、改行、UTF-8のbyte列を観察する教材です。実在の顧客・金融データは使いません。

## まず試す

~~~powershell
./New-FixedRecordDemo.ps1
~~~

一時ファイルを作成してダンプした後、finallyで削除します。

## ここを見る

- 先頭のoffset
- 半角空白 20
- CR/LFを使う場合の 0D 0A
- ASCIIと日本語でbyte数が同じではないこと

## 1か所変える

$name = 'ABC' を $name = '日本' に変え、同じ「文字数のつもり」の設計がbyte数ではどう変わるかを観察します。

## 仕事で使うなら

固定長仕様が「文字数」なのか「byte数」なのか、文字コード、改行、padding、切り詰めルールを先に確認します。見た目で合っていてもbyte offsetがずれる場合があります。

## 検証状態

PowerShell Format-Hexと.NET Encodingの公式仕様に基づく教材です。この更新時点で実機実行はしていません。

## 公式情報

- [Microsoft Learn — Format-Hex](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-hex)
- [Microsoft Learn — Encoding.GetBytes](https://learn.microsoft.com/en-us/dotnet/api/system.text.encoding.getbytes)
