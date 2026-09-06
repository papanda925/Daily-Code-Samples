# ------------------------------------------------------------
# このコードは「フィルターバブルの概念」を理解する教育用モデルです。
#
# YouTube / X / Instagram / TikTokなど、
# 実際のサービスの推薦アルゴリズムを再現しているわけではありません。
#
# 数字を動かしながら、
#
#   推薦 → クリック → 興味推定の更新 → 次の推薦
#
# というフィードバックループだけを観察します。
# ------------------------------------------------------------

# コンテンツを -100〜100 の1本の数直線上に置いたと仮定します。
#
# 例として、
# -100 = 左端のテーマ
#    0 = 中央
#  100 = 右端のテーマ
#
# のような「架空の位置」を表しています。
$content = -100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100

# hiddenInterest は、
# この仮想ユーザーが本当はどの位置を好みやすいかを表します。
#
# 45なので、ややプラス側を好むユーザーという設定です。
$hiddenInterest = 45.0

# recommenderEstimate は、
# 推薦側が現時点で推測しているユーザーの興味位置です。
#
# 最初は何も分からないので中央の0から開始します。
$recommenderEstimate = 0.0

# 12回、推薦とクリックを繰り返します。
for ($round = 1; $round -le 12; $round++) {
    # 教育用ルール1:
    # Roundが進むほど推薦件数を7件→2件へ減らします。
    #
    # これは「推定に自信が付くと表示範囲を絞る」という
    # 仮想ルールを意図的に追加したものです。
    #
    # 実サービスがこの式を使っているという意味ではありません。
    $take = [math]::Max(
        2,
        7 - [math]::Floor(($round - 1) / 2)
    )

    # 教育用ルール2:
    # 現在の推定興味に「距離が近い」コンテンツから並べます。
    #
    # Abs(コンテンツ位置 - 推定位置)
    # が小さいほど近い、としています。
    $recommended = $content |
        Sort-Object { [math]::Abs($_ - $recommenderEstimate) } |
        Select-Object -First $take

    # 教育用ルール3:
    # 表示された候補の中から、
    # hiddenInterestに最も近いものをクリックしたと仮定します。
    #
    # 実際の人間は毎回こんなに規則的には行動しません。
    # ここでは仕組みを見やすくするため単純化しています。
    $clicked = $recommended |
        Sort-Object { [math]::Abs($_ - $hiddenInterest) } |
        Select-Object -First 1

    # 推薦された中で最小値と最大値を求めます。
    #
    # この差を「そのRoundで見えた情報の幅」として観察します。
    $range = $recommended | Measure-Object -Minimum -Maximum
    $width = $range.Maximum - $range.Minimum

    # そのRoundで何が起きたかを表形式で表示します。
    [pscustomobject]@{
        Round          = $round
        EstimateBefore = [math]::Round($recommenderEstimate, 1)
        RecommendCount = $take
        Recommended    = ($recommended -join ", ")
        ExposureWidth  = $width
        Clicked        = $clicked
    } | Format-Table -AutoSize

    # 教育用ルール4:
    # 推薦側の興味推定を、クリックした位置へ30%だけ近づけます。
    #
    # 新しい推定 =
    #   以前の推定 × 70%
    #   + クリック位置 × 30%
    #
    # いきなりクリック位置へ100%移動しないことで、
    # 過去の推定も少し残す単純な平滑化になっています。
    $recommenderEstimate =
        0.7 * $recommenderEstimate +
        0.3 * $clicked
}
