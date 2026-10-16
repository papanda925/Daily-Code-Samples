# PowerShell 7: CSVのCode列に含まれるキー集合の追加・削除のみを比較。
# 元ファイルを更新しない。コードが重複・空欄なら止めて原因を明確にする。
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Before,
    [Parameter(Mandatory = $true)][string]$After
)
$ErrorActionPreference = 'Stop'

function Read-ProductCodes {
    param([Parameter(Mandatory = $true)][string]$CsvPath)

    if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
        throw "ファイルが見つかりません: $CsvPath"
    }
    # 文字コードはUTF-8を前提。CSVヘッダーはCode,Nameなどを想定する。
    $rows = @(Import-Csv -LiteralPath $CsvPath -Encoding utf8 -ErrorAction Stop)
    if ($rows.Count -eq 0) {
        throw "データが0件です: $CsvPath"
    }
    if ('Code' -notin @($rows[0].PSObject.Properties.Name)) {
        throw "Code列が存在しません: $CsvPath"
    }

    $codes = @(
        foreach ($row in $rows) {
            $code = [string]$row.Code
            if ([string]::IsNullOrWhiteSpace($code)) {
                throw "Codeが空欄です: $CsvPath"
            }
            # 前後の空白を除いて、コード全体は文字列のまま扱う。
            $code.Trim()
        }
    )

    # Compare-Objectは集合の差分を扱うため、重複件数を隠さない。
    # Sort-Object -Uniqueの既定の文字列比較は大小文字を区別しない。
    $unique = @($codes | Sort-Object -Unique)
    if ($unique.Count -ne $codes.Count) {
        throw "重複したCodeが存在します: $CsvPath"
    }

    # パイプラインから個々の文字列を返し、呼出し側は配列として捕捉する。
    $codes
}

try {
    $old = @(Read-ProductCodes -CsvPath $Before)
    $new = @(Read-ProductCodes -CsvPath $After)

    # 前回分はReferenceObject、今回分はDifferenceObject。
    $changes = @(Compare-Object -ReferenceObject $old -DifferenceObject $new)

    if ($changes.Count -eq 0) {
        Write-Output '商品コードの追加・削除なし'
    }
    else {
        # 入力順で表示が変わらないよう比較結果を並べ替える。
        foreach ($entry in ($changes | Sort-Object SideIndicator, InputObject)) {
            $action = if ($entry.SideIndicator -eq '=>') { '追加' } else { '削除' }
            [pscustomobject]@{ Change = $action; Code = $entry.InputObject }
        }
    }
}
catch {
    Write-Error "CSV比較に失敗しました: $($_.Exception.Message)"
    throw
}
