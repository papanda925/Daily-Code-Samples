# ------------------------------------------------------------
# ブロックチェーンの「ハッシュで前後をつなぐ部分」だけを
# PowerShellで体験する教育用サンプルです。
#
# BitcoinやEthereumの完全な実装ではありません。
#
# このサンプルには、
# - P2Pネットワーク
# - 電子署名
# - Proof of Work
# - 分散合意
#
# などは入っていません。
# ------------------------------------------------------------

function Get-Sha256Hex {
    param(
        # SHA-256を計算したい元の文字列です。
        [Parameter(Mandatory)]
        [string]$Text
    )

    # SHA256.Create() は .NET が提供するSHA-256実装です。
    #
    # Get-FileHashのようなPowerShell cmdletではなく、
    # .NETの暗号クラスを直接呼んでいます。
    $sha = [System.Security.Cryptography.SHA256]::Create()

    try {
        # SHA-256は「文字列」ではなくbyte列を入力に取ります。
        #
        # 同じ文字列を同じbyte列へ変換できるよう、
        # この教材ではUTF-8を使います。
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)

        # ComputeHash() の戻り値はbyte配列です。
        $hash = $sha.ComputeHash($bytes)

        # byte配列のままだと人が読みづらいため、
        # 各byteを2桁16進数へ変換して連結します。
        #
        # 例:
        #   10進数 255 → "ff"
        return -join (
            $hash | ForEach-Object { $_.ToString("x2") }
        )
    }
    finally {
        # SHA256オブジェクトが持つリソースを解放します。
        #
        # 途中で例外が起きても実行されるようfinallyに置きます。
        $sha.Dispose()
    }
}

function New-DemoBlock {
    param(
        # ブロックの通し番号です。
        [int]$Index,

        # このブロックが持つ学習用データです。
        [string]$Data,

        # 1つ前のブロックのHashを保存する欄です。
        [string]$PreviousHash
    )

    # 今回の教材では、
    #
    #   Index | Data | PreviousHash
    #
    # の3つを1本の文字列へ連結し、
    # その文字列全体からHashを計算します。
    #
    # DataだけでなくPreviousHashもHash計算へ含めることで、
    # 「前のブロックとのつながり」も現在のHashへ反映されます。
    $payload = "$Index|$Data|$PreviousHash"

    # PowerShellのカスタムオブジェクトを、
    # 1つの「ブロック」として扱います。
    [pscustomobject]@{
        Index        = $Index
        Data         = $Data
        PreviousHash = $PreviousHash
        Hash         = Get-Sha256Hex $payload
    }
}

function Test-DemoChain {
    param(
        # 検証するブロック配列です。
        [object[]]$Chain
    )

    # 先頭から1ブロックずつ検証します。
    for ($i = 0; $i -lt $Chain.Count; $i++) {
        $block = $Chain[$i]

        # 保存されているIndex / Data / PreviousHashから、
        # Hashをもう一度計算します。
        #
        # 保存済みHashと違えば、
        # ブロック内部の何かが書き換わったと判断できます。
        $recalculated = Get-Sha256Hex(
            "$($block.Index)|$($block.Data)|$($block.PreviousHash)"
        )

        if ($recalculated -ne $block.Hash) {
            return [pscustomobject]@{
                Valid  = $false
                Reason = "Block $i のHashが一致しません"
            }
        }

        # Block 0（Genesis）には前ブロックがないため、
        # PreviousHashのつながり確認はBlock 1以降だけ行います。
        if (
            $i -gt 0 -and
            $block.PreviousHash -ne $Chain[$i - 1].Hash
        ) {
            return [pscustomobject]@{
                Valid  = $false
                Reason = "Block $i のPreviousHashが前ブロックと一致しません"
            }
        }
    }

    # 最後まで不一致がなければ、この教材上では正常です。
    [pscustomobject]@{
        Valid  = $true
        Reason = "OK"
    }
}

# ------------------------------------------------------------
# ここから実際に3ブロックを作ります。
# ------------------------------------------------------------

$chain = @()

# Genesis Blockは「最初のブロック」です。
#
# 前のブロックが存在しないので、
# この教材ではPreviousHashを64個の0にしています。
# SHA-256の16進表記が64文字なので、見た目を合わせています。
$chain += New-DemoBlock 0 "Genesis" ("0" * 64)

# Block 1は、Block 0のHashをPreviousHashとして持ちます。
$chain += New-DemoBlock 1 "Alice -> Bob : 100" $chain[0].Hash

# Block 2は、Block 1のHashをPreviousHashとして持ちます。
$chain += New-DemoBlock 2 "Bob -> Carol : 40" $chain[1].Hash

# 3ブロックの内容を見える形で表示します。
$chain | Format-Table Index, Data, PreviousHash, Hash -AutoSize

# まず、書き換える前のチェーンを検証します。
Test-DemoChain $chain

# ------------------------------------------------------------
# 改ざん実験
# ------------------------------------------------------------

Write-Host ""
Write-Host "--- Block 1を書き換える ---"

# Block 1のDataだけを100→999へ書き換えます。
#
# Hashは更新していないため、
# Test-DemoChainで再計算Hashとの不一致が検出されます。
$chain[1].Data = "Alice -> Bob : 999"

Test-DemoChain $chain
