# Windows Zone.Identifierを読み取り専用で観察する

Windowsがダウンロード元情報をNTFS代替データストリームへ記録する場合、その内容を変更せず確認します。

## まず試す

```powershell
param([string]$Path)

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Host '[FAILED] ファイルが見つかりません'
    return
}

try {
    $streams = Get-Item -LiteralPath $Path -Stream * -ErrorAction Stop
    $zone = $streams | Where-Object Stream -eq 'Zone.Identifier'
    if ($zone) {
        Write-Host '[SUCCESS] Zone.Identifier を検出'
        Get-Content -LiteralPath $Path -Stream Zone.Identifier -ErrorAction Stop
    } else {
        Write-Host '[RESULT] Zone.Identifier はありません'
    }
} catch {
    Write-Host '[FAILED]' $_.Exception.Message
}
```

## ここを見る

`ZoneId` 等が見える場合があります。存在しないことも正常です。ファイルシステムや取得経路で挙動が異なります。

## 1か所変える

自分で作ったローカルのテキストファイルと、ブラウザから取得した無害なファイルを比較します。

## 仕事で使うなら

「なぜこのファイルだけ警告されるのか」の調査材料になります。Zone.Identifierを削除する操作はこの教材では扱いません。

検証状態: 実装済み・Windows実機未確認。
