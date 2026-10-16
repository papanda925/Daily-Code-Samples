# PowerShell 7向け。OS一時フォルダー配下の新規GUIDディレクトリのみへ書込む。
$ErrorActionPreference = 'Stop'

# 同名の既存ディレクトリーや業務ファイルを使用しないため、
# ランダムな識別子を追加する。勝手に他のフォルダーを削除しない。
$folder = Join-Path ([System.IO.Path]::GetTempPath()) ('literal-demo-' + [guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $folder -ErrorAction Stop

# 文字どおりの[2026]を含むファイルを作る。
# .NET File APIはワイルドカードを展開せず、渡されたパスを使う。
$file = Join-Path $folder '実績[2026].csv'
[System.IO.File]::WriteAllText($file, '')

# -LiteralPathは文字列をそのまま評価し、Pathは[]などを検索パターンとして解釈する。
$isLiteral = Test-Path -LiteralPath $file -PathType Leaf
$isPattern = Test-Path -Path $file -PathType Leaf

[pscustomobject]@{
    SampleFile       = $file
    LiteralPathFound = $isLiteral
    PatternPathFound = $isPattern
    FolderForCleanup = $folder
}

# 学習目的に削除処理は自動実行しない。
# 表示された一時フォルダーを確かめてから手動で後始末する。
