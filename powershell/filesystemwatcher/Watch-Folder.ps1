param(
    # 監視するフォルダです。
    #
    # 例:
    #   -Path C:\Temp
    [Parameter(Mandatory)]
    [string]$Path,

    # 監視対象のファイル名パターンです。
    #
    # "*"      → すべて
    # "*.txt"  → txtだけ
    [string]$Filter = "*"
)

# Resolve-Pathで実在するパスへ変換します。
# フォルダが存在しなければ -ErrorAction Stop によりここで停止します。
$resolved = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path

# FileSystemWatcher は .NET のファイル変更監視クラスです。
#
# 第1引数: 監視フォルダ
# 第2引数: 対象ファイルのフィルター
$watcher = [System.IO.FileSystemWatcher]::new($resolved, $Filter)

# falseなので、今回はサブフォルダまでは監視しません。
# trueにすると配下も対象になりますが、監視量が増えます。
$watcher.IncludeSubdirectories = $false

# NotifyFilter は「どんな種類の変化を通知対象にするか」です。
#
# -bor はPowerShellのビットOR演算子です。
# 複数のフラグを1つの値として組み合わせるために使います。
#
# FileName:
#   作成・削除・名前変更など
#
# LastWrite:
#   最終書き込み時刻の変化
#
# Size:
#   ファイルサイズの変化
$watcher.NotifyFilter =
    [System.IO.NotifyFilters]::FileName -bor
    [System.IO.NotifyFilters]::LastWrite -bor
    [System.IO.NotifyFilters]::Size

# イベント登録が全部終わる前に通知が飛ばないよう、
# まずは監視開始をOFFにしておきます。
$watcher.EnableRaisingEvents = $false

# 4種類のイベントを同じ形で登録します。
#
# Created: 作成
# Changed: 変更
# Deleted: 削除
# Renamed: 名前変更
$sourceIds = foreach ($eventName in "Created", "Changed", "Deleted", "Renamed") {
    # SourceIdentifierはイベント登録を識別するための名前です。
    #
    # 後でUnregister-Eventするとき、この名前を使って確実に解除します。
    $sourceId = "FolderWatcher.$eventName"

    # PowerShellの「スプラッティング」を使い、
    # Register-ObjectEventへ渡す引数をハッシュテーブルにまとめます。
    #
    # 引数が多いコマンドを読みやすくするテクニックです。
    $registerArgs = @{
        InputObject      = $watcher
        EventName        = $eventName
        SourceIdentifier = $sourceId
        Action           = {
            # SourceEventArgsには、
            # 「どのファイルが、どう変化したか」が入っています。
            $eventArgs = $Event.SourceEventArgs

            # RenamedイベントだけはOldFullPathを持ちます。
            # Createdなどにはないため、最初は空文字にします。
            $oldPath = ""

            if ($eventArgs.PSObject.Properties.Name -contains "OldFullPath") {
                $oldPath = $eventArgs.OldFullPath
            }

            # 受け取ったイベントを読みやすいオブジェクトにして表示します。
            #
            # ChangeType:
            #   Created / Changed / Deleted / Renamed など
            [pscustomobject]@{
                Time    = Get-Date
                Event   = [string]$eventArgs.ChangeType
                Path    = $eventArgs.FullPath
                OldPath = $oldPath
            } | Format-Table -AutoSize
        }
    }

    # Register-ObjectEventの戻り値自体は今回は使わないので、
    # Out-Nullで画面表示を抑えます。
    Register-ObjectEvent @registerArgs | Out-Null

    # 後始末用に識別子を配列へ保存します。
    $sourceId
}

# すべてのイベント登録が終わったので、
# ここで実際の監視を開始します。
$watcher.EnableRaisingEvents = $true

try {
    Write-Host "Watching: $resolved  Filter: $Filter"
    Write-Host "Ctrl+C で終了します。"

    # FileSystemWatcherはイベント駆動なので、
    # while内で毎回ファイル一覧を調べているわけではありません。
    #
    # スクリプト本体が終了しないよう、
    # 1秒ずつ待ちながらプロセスを生かしているだけです。
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    # Ctrl+Cやエラーで終了するときも、
    # Register-ObjectEventで作った登録を解除します。
    foreach ($sourceId in $sourceIds) {
        Unregister-Event -SourceIdentifier $sourceId -ErrorAction SilentlyContinue
    }

    # .NETオブジェクトが保持するOS側リソースを解放します。
    $watcher.Dispose()
}
