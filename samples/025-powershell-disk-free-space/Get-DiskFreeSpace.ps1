#requires -Version 5.1

# ローカルディスクの容量を読み取るだけのサンプルです。
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{Name='SizeGB';Expression={[math]::Round($_.Size / 1GB, 1)}},
        @{Name='FreeGB';Expression={[math]::Round($_.FreeSpace / 1GB, 1)}},
        @{Name='FreePercent';Expression={
            if ($_.Size) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 1) } else { 0 }
        }} |
    Format-Table -AutoSize
