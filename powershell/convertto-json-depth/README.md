# ConvertTo-JsonのDepthを観察する

## まず試す

```powershell
$data = [pscustomobject]@{
    Name = 'demo'
    Settings = [pscustomobject]@{
        Network = [pscustomobject]@{
            Proxy = [pscustomobject]@{ Enabled = $false; Port = 8080 }
        }
    }
}

foreach ($depth in 2, 5) {
    Write-Host "[START] Depth=$depth"
    try {
        $json = $data | ConvertTo-Json -Depth $depth -Compress
        Write-Host "[RESULT] $json"
    } catch {
        Write-Host '[FAILED]' $_.Exception.Message
    }
}
```

## ここを見る

ネストしたオブジェクトをJSON化するとき、Depthが浅いと意図した構造を十分に表現できない場合があります。警告も確認します。

## 1か所変える

Depthを3へ変え、出力の差を見ます。

## 仕事で使うなら

API送信用JSONや設定ファイル生成では、出力後にJSONを再読込して必要なキーが残っているか検証してください。

検証状態: 実装済み・未実行。
