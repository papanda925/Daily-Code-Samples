[CmdletBinding()]
param(
    # この教材では3ビットだけを定義。未知のビットを黙って切り捨てません。
    [ValidateRange(0,7)][int]$Flags = 5,
    [ValidateRange(0,7)][int]$Required = 3
)
$ErrorActionPreference = 'Stop'
try {
    # 画面用の二進数。OSの権限を変更する処理はありません。
    $binary = [Convert]::ToString($Flags,2).PadLeft(3,'0')
    $common = $Flags -band $Required
    [pscustomobject]@{
        Flags = $Flags
        Binary = $binary
        Required = $Required
        CommonBits = $common
        HasAny = ($common -ne 0)
        # Required=0ではTrue。設定不足を拒否する業務なら別途検証が必要です。
        HasAll = ($common -eq $Required)
        OrDuplicate = (1 -bor 1)
        AddDuplicate = (1 + 1)
        WithoutWrite = ($Flags -band (-bnot 2))
    }
}
catch {
    # エラー時は成功を装わず呼び出し側へ伝えます。
    throw
}
