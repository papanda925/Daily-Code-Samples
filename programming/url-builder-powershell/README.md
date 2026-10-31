# UriBuilderとEscapeDataStringでURLを組み立てる

PowerShellでURLを文字列連結せず、.NETの `UriBuilder` と `Uri.EscapeDataString` を使ってクエリ文字列を安全に組み立てる例です。

## 実行例

```powershell
./Build-Url.ps1 -BaseUrl "https://example.com/search" -Query "東京 駅" -Page 2
```

## 検証状態

Microsoft LearnのUriBuilder / Uri.EscapeDataString仕様を確認して実装。PowerShell実機確認は未実施です。

## まず試す

[Build-Url.ps1](Build-Url.ps1) はベースURL・検索語・ページ番号からURLを組み立てるPowerShellサンプルです。

```powershell
.\Build-Url.ps1 -BaseUrl 'https://example.com/search' -Query '東京 駅' -Page 2
```

**期待結果（未実行）**：`https://example.com/search?q=%E6%9D%B1%E4%BA%AC%20%E9%A7%85&page=2` に相当するURLが表示されます。実際のHTTP通信は行いません。

## コードの読みどころ

`[Uri]::EscapeDataString()` はクエリの**キーと値を個別に**エンコードします。`[ordered]` で `q` → `page` の順序を保ち、`UriBuilder.Query` へ渡します。値に `&` や空白があっても文字列を素朴に連結しない点が重要です。もともとクエリを含むURLを渡すと既存クエリが置き換えられるため注意してください。

## 失敗時・検証

ベースURLの形式が正しくないと `UriBuilder` の生成に失敗します。例示URLはダミーで、実際のAPI認証や公開URLは使わないでください。2026-10-31：GitHub上のPowerShellソースを読んで手順・期待結果を照合。実行は未実施。公式：[UriBuilder](https://learn.microsoft.com/en-us/dotnet/api/system.uribuilder)。
