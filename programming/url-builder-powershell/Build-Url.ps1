param(
    # クエリ文字列を付ける前のベースURLです。
    [string]$BaseUrl = "https://example.com/search",

    # 日本語や空白が含まれていても、
    # この後EscapeDataString()でURL向けに変換します。
    [string]$Query = "東京 駅",

    [int]$Page = 1
)

# [ordered] を使うと、キーの並び順を保ったハッシュテーブルになります。
#
# URLの意味上、クエリパラメータ順は多くの場合重要ではありませんが、
# 学習時やログ比較では順序が一定の方が読みやすいため使っています。
$params = [ordered]@{
    q    = $Query
    page = $Page
}

# GetEnumerator() で、
# q=... / page=... の各キー・値を1件ずつ処理します。
$queryString = (
    $params.GetEnumerator() | ForEach-Object {
        # EscapeDataString() は、
        # URLの「データ部分」をパーセントエンコードする .NET APIです。
        #
        # URL全体ではなく、キーと値を個別に変換するのがポイントです。
        $key = [Uri]::EscapeDataString([string]$_.Key)
        $value = [Uri]::EscapeDataString([string]$_.Value)

        # ここではまだ1項目分です。
        #
        # 例:
        #   q=%E6%9D%B1%E4%BA%AC%20%E9%A7%85
        "$key=$value"
    }
) -join "&"

# -join "&" によって、
# 複数パラメータを & でつないだクエリ文字列になります。
#
# 例:
#   q=...&page=1

# UriBuilder はURLの各部分を組み立てる .NET クラスです。
#
# 文字列を最初から最後まで手作業で連結するより、
# Scheme / Host / Path / Queryなどの構造を保ちやすくなります。
$builder = New-Object System.UriBuilder($BaseUrl)

# Queryプロパティへ、さきほど作ったクエリ文字列を設定します。
$builder.Query = $queryString

# UriBuilderが最終的に組み立てたURLを表示します。
#
# AbsoluteUriを使うことで、
# エスケープを含む絶対URLとして確認できます。
$builder.Uri.AbsoluteUri
