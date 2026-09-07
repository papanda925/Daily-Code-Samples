$ErrorActionPreference = 'Stop'

Write-Host '[START] Windows.System.Power.PowerManager を WinRT から読み込みます'

try {
    if ($env:OS -ne 'Windows_NT') {
        throw 'このサンプルは Windows PowerShell 5.1 + Windows 10/11 を対象にしています。'
    }

    # ContentType = WindowsRuntime を指定すると、Windows Runtime の型を
    # Windows PowerShell 5.1 から型リテラルとして解決できます。
    $powerManager = [Windows.System.Power.PowerManager, Windows.System.Power, ContentType = WindowsRuntime]

    $result = [pscustomobject]@{
        RemainingChargePercent = $powerManager::RemainingChargePercent
        BatteryStatus          = [string]$powerManager::BatteryStatus
        PowerSupplyStatus      = [string]$powerManager::PowerSupplyStatus
        EnergySaverStatus      = [string]$powerManager::EnergySaverStatus
        RemainingDischargeTime = $powerManager::RemainingDischargeTime
    }

    Write-Host '[SUCCESS] PowerManager のプロパティを読み取れました'
    $result.PSObject.Properties | ForEach-Object {
        Write-Host ("[RESULT] {0} = {1}" -f $_.Name, $_.Value)
    }

    Write-Host '[TRY] ACアダプターを抜き差しできる環境なら、BatteryStatus / PowerSupplyStatus の変化を観察してください'
}
catch {
    Write-Error '[FAILED] PowerManager の読み取りに失敗しました'
    Write-Error ("Type    : {0}" -f $_.Exception.GetType().FullName)
    Write-Error ("Message : {0}" -f $_.Exception.Message)
    exit 1
}
