$Read  = 1   # 0001
$Write = 2   # 0010
$Delete = 4  # 0100

$flags = $Read -bor $Write

Write-Host ("flags        = {0} ({1})" -f $flags, [Convert]::ToString($flags, 2).PadLeft(4, '0'))
Write-Host ("has Read     = {0}" -f (($flags -band $Read) -ne 0))
Write-Host ("has Write    = {0}" -f (($flags -band $Write) -ne 0))
Write-Host ("has Delete   = {0}" -f (($flags -band $Delete) -ne 0))

if ($flags -eq 3 -and ($flags -band $Read) -ne 0 -and ($flags -band $Write) -ne 0 -and ($flags -band $Delete) -eq 0) {
    Write-Host "[SUCCESS] bit flags behaved as expected"
    exit 0
}

Write-Host "[FAILED] unexpected bit flag result"
exit 1
