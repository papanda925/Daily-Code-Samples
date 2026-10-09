# PowerShell 7+ / 無害な一時ディレクトリだけを使う JSONL 学習サンプル
# 元ファイルや本番ログにはアクセスしない
[CmdletBinding()]
param(
    [switch] $KeepFiles
)

$ErrorActionPreference = 'Stop'
$work = Join-Path ([System.IO.Path]::GetTempPath()) ('jsonl-demo-' + [guid]::NewGuid().ToString('N'))
$log = Join-Path $work 'events.jsonl'

try {
    New-Item -ItemType Directory -Path $work -ErrorAction Stop | Out-Null

    # 同じ形式のイベントを1件ずつ、必ず1行のJSONとして追記する
    $events = @(
        [ordered]@{ event_id = 'evt-001'; status = 'START'; message = '開始' }
        [ordered]@{ event_id = 'evt-002'; status = 'DONE';  message = '完了' }
    )

    foreach ($event in $events) {
        $line = ConvertTo-Json -InputObject $event -Compress -Depth 5 -ErrorAction Stop
        Add-Content -LiteralPath $log -Value $line -Encoding utf8NoBOM -ErrorAction Stop
    }

    # 末尾1レコードだけ壊れたケースを再現する（学習用）
    Add-Content -LiteralPath $log -Value '{broken json' -Encoding utf8NoBOM -ErrorAction Stop

    $valid = 0
    $invalid = 0
    $number = 0
    foreach ($line in Get-Content -LiteralPath $log -Encoding utf8 -ErrorAction Stop) {
        $number++
        if ([string]::IsNullOrWhiteSpace($line)) {
            $invalid++
            Write-Warning ('line {0}: blank line is not valid JSONL' -f $number)
            continue
        }

        try {
            $record = ConvertFrom-Json -InputObject $line -ErrorAction Stop
            if ($null -eq $record -or [string]::IsNullOrWhiteSpace([string]$record.event_id)) {
                throw 'event_id is missing'
            }
            $valid++
            Write-Output ('[OK] line={0} event_id={1} status={2}' -f $number, $record.event_id, $record.status)
        }
        catch {
            $invalid++
            Write-Warning ('line {0}: invalid record (details omitted)' -f $number)
        }
    }

    Write-Output ('[RESULT] valid={0} invalid={1}' -f $valid, $invalid)
    if ($KeepFiles) {
        Write-Output ('[FILE] {0}' -f $log)
    }
}
finally {
    if (-not $KeepFiles -and (Test-Path -LiteralPath $work)) {
        Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction Stop
    }
}
