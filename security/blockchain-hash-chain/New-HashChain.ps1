function Get-Sha256Hex {
    param([Parameter(Mandatory)][string]$Text)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $hash = $sha.ComputeHash($bytes)
        return -join ($hash | ForEach-Object { $_.ToString("x2") })
    }
    finally {
        $sha.Dispose()
    }
}

function New-DemoBlock {
    param(
        [int]$Index,
        [string]$Data,
        [string]$PreviousHash
    )

    $payload = "$Index|$Data|$PreviousHash"

    [pscustomobject]@{
        Index        = $Index
        Data         = $Data
        PreviousHash = $PreviousHash
        Hash         = Get-Sha256Hex $payload
    }
}

function Test-DemoChain {
    param([object[]]$Chain)

    for ($i = 0; $i -lt $Chain.Count; $i++) {
        $block = $Chain[$i]
        $recalculated = Get-Sha256Hex "$($block.Index)|$($block.Data)|$($block.PreviousHash)"

        if ($recalculated -ne $block.Hash) {
            return [pscustomobject]@{ Valid = $false; Reason = "Block $i のHashが一致しません" }
        }

        if ($i -gt 0 -and $block.PreviousHash -ne $Chain[$i - 1].Hash) {
            return [pscustomobject]@{ Valid = $false; Reason = "Block $i のPreviousHashが前ブロックと一致しません" }
        }
    }

    [pscustomobject]@{ Valid = $true; Reason = "OK" }
}

$chain = @()
$chain += New-DemoBlock 0 "Genesis" ("0" * 64)
$chain += New-DemoBlock 1 "Alice -> Bob : 100" $chain[0].Hash
$chain += New-DemoBlock 2 "Bob -> Carol : 40" $chain[1].Hash

$chain | Format-Table Index, Data, PreviousHash, Hash -AutoSize
Test-DemoChain $chain

Write-Host ""
Write-Host "--- Block 1を書き換える ---"
$chain[1].Data = "Alice -> Bob : 999"
Test-DemoChain $chain
