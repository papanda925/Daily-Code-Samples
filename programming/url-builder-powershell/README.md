# UriBuilderとEscapeDataStringでURLを組み立てる

PowerShellでURLを文字列連結せず、.NETの `UriBuilder` と `Uri.EscapeDataString` を使ってクエリ文字列を安全に組み立てる例です。

## 実行例

```powershell
./Build-Url.ps1 -BaseUrl "https://example.com/search" -Query "東京 駅" -Page 2
```

## 検証状態

Microsoft LearnのUriBuilder / Uri.EscapeDataString仕様を確認して実装。PowerShell実機確認は未実施です。
