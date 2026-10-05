$template = 'Temp=%TEMP%; Missing=%PAPANDA_NOT_SET%'
$result = [Environment]::ExpandEnvironmentVariables($template)

Write-Host "template = $template"
Write-Host "result   = $result"

$hasTempExpanded = -not $result.Contains('%TEMP%')
$missingPreserved = $result.Contains('%PAPANDA_NOT_SET%')

if ($hasTempExpanded -and $missingPreserved) {
    Write-Host "[SUCCESS] set variables expanded and missing variables stayed unchanged"
    exit 0
}

Write-Host "[FAILED] unexpected expansion result"
exit 1
