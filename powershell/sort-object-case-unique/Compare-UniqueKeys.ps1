# PowerShell 7.5の文字列比較を観察する読取り専用デモ。
$values = @('P101', 'p101', 'P102', 'P101', 'p103')
'入力:'; $values

# 通常の-Uniqueは大文字小文字を区別せず重複を除く。
'既定の-Unique:'
$values | Sort-Object -Unique

# 区別する場合はCaseSensitiveも指定する。
'CaseSensitiveとUnique:'
$values | Sort-Object -CaseSensitive -Unique

# 商品コードの仕様が未確定なら無断でどちらかを正としない。
