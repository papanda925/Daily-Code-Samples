Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $rows = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object {
        [pscustomobject]@{
            ProcessName = $_.ProcessName
            Id = $_.Id
            MainWindowTitle = $_.MainWindowTitle
            HwndDecimal = [int64]$_.MainWindowHandle
            HwndHex = ('0x{0:X}' -f [int64]$_.MainWindowHandle)
        }
    }

    if (-not $rows) {
        Write-Host '[RESULT] No process with a main window was found.'
        exit 0
    }

    $rows | Sort-Object ProcessName,Id | Format-Table -AutoSize
    Write-Host "[SUCCESS] Window count = $($rows.Count)"
}
catch {
    Write-Error "[FAILED] $($_.Exception.Message)"
    exit 1
}
