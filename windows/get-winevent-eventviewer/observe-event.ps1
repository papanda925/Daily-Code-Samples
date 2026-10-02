Write-Host "[START] Systemログの直近5件を読み取ります"
$events = Get-WinEvent -LogName System -MaxEvents 5 -ErrorAction Stop |
    Select-Object TimeCreated, Id, ProviderName, LevelDisplayName

$events | Format-Table -AutoSize
Write-Host "[OBSERVE] eventvwr.msc > Windows ログ > システム で時刻とEvent IDを探してください"
Write-Host "[SUCCESS] 読み取りのみで取得しました"
