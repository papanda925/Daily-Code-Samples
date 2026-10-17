# Sort-Objectで大文字小文字を区別する重複判定

元記事：[Sort-Object -Uniqueの重複判定](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-20/body.md)。商品コードを想定した文字列配列から、`-Unique`と`-CaseSensitive -Unique`の違いを観察します。

## まず試す

PowerShell 7で `./Compare-UniqueKeys.ps1` を実行。ファイルの作成・削除はありません。入力はP101、p101、P102、P101、p103の5件。通常の-UniqueではP101とp101を別物として保持しない想定です（実機未実行）。

## ここを見る

`Sort-Object -Unique` は並べ替え後に重複を排除します。PowerShellの文字列比較では大文字小文字の区別が暗黙に入らない場合があること、CaseSensitiveの指定で結果が変わることを確認します。**先頭の値がどちらになるかを業務の正解と決めない**ことが重要です。

## 1か所変える

入力から小文字p101を削除して再実行。既定の-UniqueとCaseSensitiveを指定した場合の件数差がなくなることが期待されます。

## 仕事で使うなら

識別子として大文字小文字が意味を持つサービスでは既定の重複排除がデータ喪失につながり得ます。ユーザー名・商品コード・メールアドレスでは比較規則が異なるので、業務仕様を先に定義。勝手な正規化や数字への変換を避けます。

## 出典・状態

[Microsoft Learn Sort-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?view=powershell-7.5)。2026-10-17仕様確認。実機試験は未実施。
