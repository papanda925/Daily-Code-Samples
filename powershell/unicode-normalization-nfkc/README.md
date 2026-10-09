# Unicode NFKC正規化をPowerShellの.NET APIで観察する

```powershell
.\Normalize-Demo.ps1
```

表示のみで、ファイル・レジストリを変更しません。

例: `ＡＢＣ１２３` → `ABC123`。半角カナや丸付き数字も変換されます。NFKCは見た目が近い文字を互換等価として統一し、**元の文字へ可逆復元できる処理ではありません**。

検索キーやダミーCSVのクリーニングに使うときは、変換前後を突き合わせてから適用してください。ユーザーID・商品コード・パスワード・ファイル名などを一律正規化すると、もともと異なる値が衝突する場合があります。

- https://learn.microsoft.com/en-us/dotnet/api/system.text.normalizationform
- https://learn.microsoft.com/en-us/dotnet/api/system.string.normalize

**検証状態：.NET公式仕様確認済み。PowerShell実機未確認。**
