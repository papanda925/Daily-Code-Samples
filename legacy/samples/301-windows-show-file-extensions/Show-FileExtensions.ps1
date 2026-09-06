param(
    [ValidateSet('Show','Hide','Status')]
    [string]$Mode = 'Status'
)

# Windowsのエクスプローラーは、既知のファイル種類の「.xlsx」「.pdf」などを
# 表示するかどうかをユーザーごとの設定として保存しています。
# この値はPC全体ではなく「今ログインしている自分」の設定なので、管理者権限は不要です。
$explorerAdvanced = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$propertyName = 'HideFileExt'

function Get-ExtensionSetting {
    # HideFileExt = 0 なら「隠さない」= 拡張子を表示。
    # HideFileExt = 1 なら「隠す」= 拡張子を非表示。
    # 値が見つからない環境もあるため、その場合は Unknown として扱います。
    try {
        $value = (Get-ItemProperty -Path $explorerAdvanced -Name $propertyName -ErrorAction Stop).$propertyName
    }
    catch {
        return [pscustomobject]@{
            RawValue = $null
            Display  = 'Unknown'
        }
    }

    [pscustomobject]@{
        RawValue = $value
        Display  = if ($value -eq 0) { '拡張子を表示' } else { '拡張子を非表示' }
    }
}

if ($Mode -eq 'Status') {
    $current = Get-ExtensionSetting
    Write-Host "現在の設定: $($current.Display)"
    Write-Host "設定値 HideFileExt: $($current.RawValue)"
    return
}

# 設定変更前の値を表示してから1か所だけ変更します。
# Showでは0、Hideでは1を保存します。
$before = Get-ExtensionSetting
$newValue = if ($Mode -eq 'Show') { 0 } else { 1 }
Set-ItemProperty -Path $explorerAdvanced -Name $propertyName -Type DWord -Value $newValue
$after = Get-ExtensionSetting

Write-Host "変更前: $($before.Display)"
Write-Host "変更後: $($after.Display)"
Write-Host ''
Write-Host 'エクスプローラーの表示がすぐ変わらない場合は、開いているフォルダーを閉じて開き直してください。'
Write-Host '元に戻すには、このスクリプトを -Mode Hide または -Mode Show で反対の設定にしてください。'
