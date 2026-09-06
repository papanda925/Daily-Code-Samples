param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$Filter = "*"
)

$resolved = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
$watcher = [System.IO.FileSystemWatcher]::new($resolved, $Filter)
$watcher.IncludeSubdirectories = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor
                        [System.IO.NotifyFilters]::LastWrite -bor
                        [System.IO.NotifyFilters]::Size
$watcher.EnableRaisingEvents = $true

$registrations = foreach ($eventName in "Created", "Changed", "Deleted", "Renamed") {
    Register-ObjectEvent -InputObject $watcher -EventName $eventName -Action {
        $args = $Event.SourceEventArgs
        $oldPath = ""

        if ($args.PSObject.Properties.Name -contains "OldFullPath") {
            $oldPath = $args.OldFullPath
        }

        [pscustomobject]@{
            Time    = Get-Date
            Event   = $Event.SourceIdentifier.Split(".")[-1]
            Path    = $args.FullPath
            OldPath = $oldPath
        } | Format-Table -AutoSize
    }
}

try {
    Write-Host "Watching: $resolved  Filter: $Filter"
    Write-Host "Ctrl+C で終了します。"
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    $registrations | Unregister-Event -ErrorAction SilentlyContinue
    $watcher.Dispose()
}
