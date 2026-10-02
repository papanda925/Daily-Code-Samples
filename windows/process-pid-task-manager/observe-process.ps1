# 自分自身のPowerShellプロセスを取得します。
$self = Get-Process -Id $PID

Write-Host "[START] PowerShellからPIDを確認します"
Write-Host ("[RESULT] Name={0} PID={1}" -f $self.ProcessName, $self.Id)

Write-Host "
[OBSERVE] タスクマネージャー > 詳細 で同じPIDを探してください"
Get-Process |
    Sort-Object ProcessName |
    Select-Object -First 10 ProcessName, Id
Write-Host "[SUCCESS] 読み取りだけで取得しました"
