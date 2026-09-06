param(
    [string]$BaseUrl = "https://example.com/search",
    [string]$Query = "東京 駅",
    [int]$Page = 1
)

$params = [ordered]@{
    q    = $Query
    page = $Page
}

$queryString = (
    $params.GetEnumerator() | ForEach-Object {
        $key = [Uri]::EscapeDataString([string]$_.Key)
        $value = [Uri]::EscapeDataString([string]$_.Value)
        "$key=$value"
    }
) -join "&"

$builder = New-Object System.UriBuilder($BaseUrl)
$builder.Query = $queryString

$builder.Uri.AbsoluteUri
