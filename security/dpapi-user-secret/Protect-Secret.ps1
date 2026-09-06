param(
    # Protect:
    #   文字列をDPAPIで保護してファイルへ保存します。
    #
    # Unprotect:
    #   保存済みファイルを同じWindowsユーザーで復号します。
    [Parameter(Mandatory)]
    [ValidateSet("Protect", "Unprotect")]
    [string]$Mode,

    # 暗号化されたバイト列を保存するファイルパスです。
    [Parameter(Mandatory)]
    [string]$Path
)

# DPAPIにはCurrentUserとLocalMachineなどのスコープがあります。
#
# CurrentUserを選ぶと、
# 「このWindowsユーザーのコンテキストで保護・復号する」
# という意味になります。
#
# これはパスワードをコードへ埋め込む方式ではありませんが、
# 同じユーザーなら復号できるため、万能な秘密管理ではありません。
$scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser

if ($Mode -eq "Protect") {
    # -AsSecureString を付けると、入力内容を画面へそのまま表示しません。
    #
    # ただし SecureString は「絶対に平文にならない魔法の箱」ではありません。
    # DPAPIへ渡すため、この後一時的に通常文字列・byte配列へ変換します。
    $secure = Read-Host "保護する文字列" -AsSecureString

    # SecureStringの中身を取り出すため、
    # WindowsのBSTRというメモリ形式へ一時変換します。
    #
    # 後で ZeroFreeBSTR() して、確保した領域を消して解放します。
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)

    # finally で存在確認して消去できるよう、最初は $null にします。
    $bytes = $null

    try {
        # BSTRから通常の.NET文字列へ変換します。
        # この $plain には一時的に平文が入るので、
        # ログへ出したりWrite-Hostしないようにします。
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)

        # ProtectedData.Protect() はbyte配列を受け取るため、
        # 文字列をUTF-8のbyte配列へ変換します。
        $bytes = [Text.Encoding]::UTF8.GetBytes($plain)

        # Windows DPAPIでbyte配列を保護します。
        #
        # 第2引数 $null:
        #   追加エントロピーは今回使わない
        #
        # 第3引数 $scope:
        #   CurrentUserスコープで保護する
        $protected = [System.Security.Cryptography.ProtectedData]::Protect(
            $bytes,
            $null,
            $scope
        )

        # 保護後のバイト列は文字列ではないため、
        # WriteAllBytes() でバイナリファイルとして保存します。
        [IO.File]::WriteAllBytes($Path, $protected)

        Write-Host "保存しました: $Path"
    }
    finally {
        # 平文のUTF-8 byte配列が残り続けないよう、
        # 可能な範囲で0クリアします。
        if ($bytes) {
            [Array]::Clear($bytes, 0, $bytes.Length)
        }

        # SecureStringから変換したBSTR領域も、
        # 0で消してからメモリを解放します。
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    # Protect処理が終わったら、
    # 下にあるUnprotect処理へ進まないよう終了します。
    return
}

# ---------- ここから Unprotect ----------

# 保存したバイナリファイルをbyte配列として読み込みます。
$protected = [IO.File]::ReadAllBytes($Path)

# Protect時と同じCurrentUserスコープで復号します。
#
# 別ユーザーや必要なDPAPI情報がない環境では、
# ここで復号に失敗する可能性があります。
$bytes = [System.Security.Cryptography.ProtectedData]::Unprotect(
    $protected,
    $null,
    $scope
)

try {
    # 学習用なので、復号したbyte配列をUTF-8文字列へ戻して出力します。
    #
    # 実運用では秘密をコンソールやログへ表示せず、
    # 必要な処理へ直接渡す設計を検討してください。
    [Text.Encoding]::UTF8.GetString($bytes)
}
finally {
    # 復号後の平文byte配列も、使い終わったら0クリアします。
    [Array]::Clear($bytes, 0, $bytes.Length)
}
