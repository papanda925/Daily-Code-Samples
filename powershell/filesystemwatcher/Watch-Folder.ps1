param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$Filter = "*"
)

$resolved = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
$watcher = [System.IO.FileSystemWatcher]::new($resolved, $Filter)
$watcher.IncludeSubdirectories = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::Size
$watcher.EnableRaisingEvents = $false

$sourceIds = foreach ($eventName in "Created", "Changed", "Deleted", "Renamed") {
    $sourceId = "FolderWatcher.$eventName"

    Register-ObjectEvent -InputObject $watcher -EventName $eventName -SourceIdentifier $sourceId -Action {
        $args = $Event.SourceEventArgs
        $oldPath = ""

        if ($args.PSObject.Properties.Name -contains "OldFullPath") {
            $oldPath = $args.OldFullPath
        }

        [pscustomobject]@{
            Time    = Get-Date
            Event   = [string]$args.ChangeType
            Path    = $args.FullPath
            OldPath = $oldPath
        } | Format-Table -AutoSize
    } | Out-Null

    $sourceId
}

$watcher.EnableRaisingEvents = $true

try {
    Write-Host "Watching: $resolved  Filter: $Filter"
    Write-Host "Ctrl+C で終了します。"

    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    foreach ($sourceId in $sourceIds) {
        Unregister-Event -SourceIdentifier $sourceId -ErrorAction SilentlyContinue
    }

    $watcher.Dispose()
}
