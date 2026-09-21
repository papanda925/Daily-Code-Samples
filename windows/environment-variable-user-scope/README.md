# ユーザー環境変数を変更してGUIで答え合わせする

一時的な教材用変数 `PAPANDA_DEMO` をユーザースコープへ保存し、元の値へ戻します。

## まず試す

```powershell
$name = 'PAPANDA_DEMO'
$before = [Environment]::GetEnvironmentVariable($name, 'User')
try {
    Write-Host "[START] Before=$before"
    [Environment]::SetEnvironmentVariable($name, 'hello', 'User')
    $after = [Environment]::GetEnvironmentVariable($name, 'User')
    Write-Host "[SUCCESS] User scope=$after"
    Write-Host 'GUI: システムのプロパティ > 詳細設定 > 環境変数 で PAPANDA_DEMO を確認'
} finally {
    [Environment]::SetEnvironmentVariable($name, $before, 'User')
    Write-Host '[RESULT] 元の値へ戻しました'
}
```

## ここを見る

現在のPowerShellプロセスの `$env:PAPANDA_DEMO` と、ユーザースコープへ保存された値は別物です。既存プロセスへ自動反映されない点を観察します。

## 1か所変える

保存値を `hello2` に変え、GUI表示だけが変わることを確認します。

## 仕事で使うなら

PATH等の重要変数ではなく、まず専用の教材変数でスコープを理解してください。

検証状態: 実装済み・Windows実機未確認。
