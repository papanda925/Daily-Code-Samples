# PowerShellでJSONの値と型を確認する

`ConvertFrom-Json` でダミーJSONをPowerShellオブジェクトへ変換し、「見た目が似ていても型が違う」ことを観察する教材です。

> 状態: implemented / PowerShell実行確認は未実施

## まず試す

```powershell
.\Show-JsonValueType.ps1
```

サンプルはファイルを変更せず、スクリプト内のダミーJSONだけを使います。

## ここを見る

`30` と `"30"`、`true` と `"true"` のように、表示だけでは紛らわしい値を `GetType()` と一緒に表示します。

設定ファイルを扱うときは「値がある」だけでなく「期待した型か」を見ることが重要です。

## 1か所変える

`-UseStringPort` を付けます。

```powershell
.\Show-JsonValueType.ps1 -UseStringPort
```

portを数値から文字列へ1か所だけ変え、型チェック結果がどう変化するか観察します。

## 仕事で使うなら

- APIレスポンスの事前確認
- JSON設定ファイルのレビュー
- AIが生成したJSONを実処理へ渡す前の型確認
- boolean / number / string の取り違えによる不具合調査

## ファイル

- `Show-JsonValueType.ps1`

## 検証状態

Microsoft PowerShell仕様を基に実装していますが、追加時点では実行証拠がないため `tested` ではありません。
