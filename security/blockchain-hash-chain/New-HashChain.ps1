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

function New-DemoChain {
    $chain = @()
    $chain += New-DemoBlock 0 "Genesis" ("0" * 64)
    $chain += New-DemoBlock 1 "Alice -> Bob : 100" $chain[0].Hash
    $chain += New-DemoBlock 2 "Bob -> Carol : 40" $chain[1].Hash
    return ,$chain
}

function Test-DemoChain {
    param([object[]]$Chain)

    for ($i = 0; $i -lt $Chain.Count; $i++) {
        $block = $Chain[$i]
        $recalculated = Get-Sha256Hex(
            "$($block.Index)|$($block.Data)|$($block.PreviousHash)"
        )

        if ($recalculated -ne $block.Hash) {
            return [pscustomobject]@{
                Valid  = $false
                Reason = "Block $i のHashが一致しません"
            }
        }

        if ($i -gt 0 -and $block.PreviousHash -ne $Chain[$i - 1].Hash) {
            return [pscustomobject]@{
                Valid  = $false
                Reason = "Block $i のPreviousHashが前ブロックと一致しません"
            }
        }
    }

    [pscustomobject]@{ Valid = $true; Reason = "OK" }
}

Write-Host "=== 正常なチェーン ==="
$chain = New-DemoChain
$chain | Format-Table Index, Data, PreviousHash, Hash -AutoSize
$result = Test-DemoChain $chain
$result
if (-not $result.Valid) { throw "[FAILED] initial chain validation failed" }

Write-Host ""
Write-Host "=== 実験1: Block 1のDataだけを100→999へ変更 ==="
$chain[1].Data = "Alice -> Bob : 999"
$result = Test-DemoChain $chain
$result
if ($result.Valid -or $result.Reason -notlike "Block 1*") {
    throw "[FAILED] direct tamper was not detected"
}
Write-Host "[SUCCESS] Block 1自身のHash不一致を検出"

Write-Host ""
Write-Host "=== 実験2: 改ざん後のBlock 1 Hashだけを再計算 ==="
# Block 1だけ帳尻を合わせても、Block 2は古いBlock 1 Hashを保持しています。
$chain[1].Hash = Get-Sha256Hex(
    "$($chain[1].Index)|$($chain[1].Data)|$($chain[1].PreviousHash)"
)
$result = Test-DemoChain $chain
$result
if ($result.Valid -or $result.Reason -notlike "Block 2*") {
    throw "[FAILED] downstream link break was not detected"
}
Write-Host "[SUCCESS] Block 2のPreviousHash不一致を検出"
