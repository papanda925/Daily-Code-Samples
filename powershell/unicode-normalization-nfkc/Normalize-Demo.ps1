# PowerShell 7 / Windows PowerShell 5.1, no file writes
$values = @(
    'ＡＢＣ１２３',
    'ｶﾀｶﾅ',
    '① Ⅳ'
)
$results = foreach ($original in $values) {
    $normalized = $original.Normalize([Text.NormalizationForm]::FormKC)
    [pscustomobject]@{
        Before = $original
        After  = $normalized
        Changed = ($original -cne $normalized)
    }
}
$results | Format-Table -AutoSize
