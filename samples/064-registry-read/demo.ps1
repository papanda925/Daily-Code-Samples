Get-ItemProperty HKCU:\Environment -ErrorAction SilentlyContinue | Select-Object * -ExcludeProperty PS*
