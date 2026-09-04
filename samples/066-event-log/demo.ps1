Get-WinEvent -LogName System -MaxEvents 20|Select-Object TimeCreated,Id,LevelDisplayName,ProviderName
