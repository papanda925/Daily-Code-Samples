param([string]$Path = "./not-found.txt")
try {
    $content = Get-Content -LiteralPath $Path -ErrorAction Stop
    [pscustomobject]@{ Status="SUCCESS"; Lines=@($content).Count; Path=$Path }
}
catch {
    [pscustomobject]@{ Status="FAILED"; Path=$Path; Error=$_.Exception.Message }
}
finally {
    Write-Host "FINALLY: cleanup point"
}
