if(Get-Command Get-MpComputerStatus -EA 0){Get-MpComputerStatus|Select AntivirusEnabled,RealTimeProtectionEnabled,AntispywareEnabled,QuickScanAge}else{"Defender cmdlet unavailable"}
