# Compare-ObjectでCSVの差分を見る

CSVの更新前後を、元ファイルを変更せず比較する教材です。

## まず試す

```powershell
$before = @'
Id,Name
1,Alice
2,Bob
'@ | ConvertFrom-Csv
$after = @'
Id,Name
1,Alice
2,Robert
3,Carol
'@ | ConvertFrom-Csv

try {
    $diff = Compare-Object -ReferenceObject $before -DifferenceObject $after -Property Id,Name
    if ($null -eq $diff) {
        Write-Host '[SUCCESS] 差分はありません'
    } else {
        Write-Host '[SUCCESS] 差分を検出しました'
        $diff | Format-Table Id,Name,SideIndicator -AutoSize
    }
} catch {
    Write-Host '[FAILED]' $_.Exception.Message
}
```

## ここを見る

`=>` は更新後側だけ、`<=` は更新前側だけに存在する行です。変更行は「旧行」と「新行」の2行として見えます。

## 1か所変える

`Robert` を `Bob` に戻し、差分が減ることを確認します。

## 仕事で使うなら

月次CSVの差分確認では、比較キーが一意かを先に確認してください。列順や空白、型の違いも差分になります。

## 注意点

この例は読み取り専用です。実ファイルへ適用する前に、重複IDや文字コードを確認してください。

検証状態: 実装済み・未実行。
