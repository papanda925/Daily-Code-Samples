$template = 'System=%SystemRoot%;Temp=%TEMP%;Missing=%PAPANDA_NOT_SET%'

Write-Host "[INPUT]  $template"
$result = [Environment]::ExpandEnvironmentVariables($template)
Write-Host "[OUTPUT] $result"

if ($result -match '%PAPANDA_NOT_SET%') {
    Write-Host "[SUCCESS] unset variable stayed unchanged as documented"
    exit 0
}

Write-Host "[FAILED] unexpected expansion result"
exit 1
