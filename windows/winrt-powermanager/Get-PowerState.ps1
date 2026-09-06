$PowerManager = [Windows.System.Power.PowerManager, Windows.System.Power, ContentType = WindowsRuntime]

[pscustomobject]@{
    RemainingChargePercent = $PowerManager::RemainingChargePercent
    BatteryStatus          = [string]$PowerManager::BatteryStatus
    PowerSupplyStatus      = [string]$PowerManager::PowerSupplyStatus
    EnergySaverStatus      = [string]$PowerManager::EnergySaverStatus
    RemainingDischargeTime = $PowerManager::RemainingDischargeTime
}
