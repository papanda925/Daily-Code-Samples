#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAILY_REPO="${DAILY_CODE_REPO:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

: "${POSTBOT_ROOT:?Set POSTBOT_ROOT in the private server environment file.}"

PYTHON_BIN="${PYTHON_BIN:-$POSTBOT_ROOT/venv/bin/python}"
BLOG_DISPATCHER="${BLOG_DISPATCHER:-$POSTBOT_ROOT/tools/production_dispatcher.py}"

# WordPressへDaily Codeを流す時刻。
DAILY_CODE_HOUR="${DAILY_CODE_HOUR:-14}"
DAILY_CODE_GRACE_MINUTES="${DAILY_CODE_GRACE_MINUTES:-10}"

# #301以降を1日1本増やす処理。
# 公開サンプルではOFFを既定にし、本番サーバーの非公開envで明示的に有効化します。
DAILY_SAMPLE_GENERATOR_ENABLED="${DAILY_SAMPLE_GENERATOR_ENABLED:-0}"
DAILY_SAMPLE_GENERATE_HOUR="${DAILY_SAMPLE_GENERATE_HOUR:-6}"
DAILY_SAMPLE_GENERATE_GRACE_MINUTES="${DAILY_SAMPLE_GENERATE_GRACE_MINUTES:-10}"

hour="$(date +%H)"
minute="$(date +%M)"

# 既存タイマーの06:00枠などを利用して「新しい1本」を先に作れます。
# ここで失敗しても、その時間帯に本来動く既存ブログdispatcherは止めません。
# 生成側は一時git worktreeを使うため、失敗した途中コードでmainを汚しません。
if [[ "$DAILY_SAMPLE_GENERATOR_ENABLED" == "1" \
   && "$((10#$hour))" -eq "$((10#$DAILY_SAMPLE_GENERATE_HOUR))" \
   && "$((10#$minute))" -le "$((10#$DAILY_SAMPLE_GENERATE_GRACE_MINUTES))" ]]; then
    echo "[daily-code] generating one new sample before normal blog dispatch"
    if ! "$PYTHON_BIN" "$DAILY_REPO/automation/ubuntu/generate_daily_sample_once.py"; then
        echo "[daily-code] WARNING: sample generation failed; normal blog dispatch will continue" >&2
    fi
fi

# 指定した1枠だけWordPressのDaily Code記事へ分岐します。
# 二重投稿防止はrun_daily_code_once.py側のstateで行います。
# article_ready=false の新規自動生成サンプルは、レビュー前なのでここでは選ばれません。
if [[ "$((10#$hour))" -eq "$((10#$DAILY_CODE_HOUR))" \
   && "$((10#$minute))" -le "$((10#$DAILY_CODE_GRACE_MINUTES))" ]]; then
    exec "$PYTHON_BIN" "$DAILY_REPO/automation/ubuntu/run_daily_code_once.py"
fi

# それ以外の枠は既存ブログdispatcherへ戻します。
exec "$PYTHON_BIN" "$BLOG_DISPATCHER"
