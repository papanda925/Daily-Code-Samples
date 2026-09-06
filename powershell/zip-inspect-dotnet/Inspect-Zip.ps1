param(
    [Parameter(Mandatory)]
    [string]$Path
)

$resolved = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolved)

try {
    $entries = $archive.Entries | ForEach-Object {
        [pscustomobject]@{
            Name           = $_.FullName
            Size           = $_.Length
            CompressedSize = $_.CompressedLength
            LastWriteTime  = $_.LastWriteTime
            IsDirectory    = $_.FullName.EndsWith("/")
        }
    }

    $entries | Format-Table -AutoSize

    $fileEntries = $entries | Where-Object { -not $_.IsDirectory }
    [pscustomobject]@{
        Archive         = $resolved
        FileCount       = @($fileEntries).Count
        TotalBytes      = ($fileEntries | Measure-Object Size -Sum).Sum
        CompressedBytes = ($fileEntries | Measure-Object CompressedSize -Sum).Sum
    }
}
finally {
    $archive.Dispose()
}
