# PowerShell 7向け。ディスク上のファイルを作らない文字列デモ。
[CmdletBinding()]
param([char]$Delimiter = ';')
$ErrorActionPreference = 'Stop'
$lines = @(
    'Code;Qty;Memo'
    'P001;2;pen'
    'P002;4;notebook'
)
$rows = @($lines | ConvertFrom-Csv -Delimiter $Delimiter)
if ($rows.Count -eq 0) { throw 'CSVのデータ行がありません' }

$names = @($rows[0].PSObject.Properties.Name)
foreach ($required in @('Code','Qty','Memo')) {
    if ($required -notin $names) {
        throw "必須列が見つかりません: $required / 実列: $($names -join ',')"
    }
}
# 値は文字列なので、数値として使う場合には別途検証する。
foreach ($r in $rows) {
    [pscustomobject]@{
        Code = [string]$r.Code
        QtyText = [string]$r.Qty
        Memo = [string]$r.Memo
    }
}
