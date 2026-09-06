$content = -100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100
$hiddenInterest = 45.0
$recommenderEstimate = 0.0

for ($round = 1; $round -le 12; $round++) {
    # 教育用ルール:
    # 推定に自信が付くほど、推薦件数を7件→2件へ段階的に絞る。
    # 実サービスの実装を再現するものではありません。
    $take = [math]::Max(2, 7 - [math]::Floor(($round - 1) / 2))

    $recommended = $content |
        Sort-Object { [math]::Abs($_ - $recommenderEstimate) } |
        Select-Object -First $take

    $clicked = $recommended |
        Sort-Object { [math]::Abs($_ - $hiddenInterest) } |
        Select-Object -First 1

    $range = $recommended | Measure-Object -Minimum -Maximum
    $width = $range.Maximum - $range.Minimum

    [pscustomobject]@{
        Round          = $round
        EstimateBefore = [math]::Round($recommenderEstimate, 1)
        RecommendCount = $take
        Recommended    = ($recommended -join ", ")
        ExposureWidth  = $width
        Clicked        = $clicked
    } | Format-Table -AutoSize

    $recommenderEstimate = 0.7 * $recommenderEstimate + 0.3 * $clicked
}
