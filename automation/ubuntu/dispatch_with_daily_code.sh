#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAILY_REPO="${DAILY_CODE_REPO:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

: "${POSTBOT_ROOT:?Set POSTBOT_ROOT in the private server environment file.}"

PYTHON_BIN="${PYTHON_BIN:-$POSTBOT_ROOT/venv/bin/python}"
BLOG_DISPATCHER="${BLOG_DISPATCHER:-$POSTBOT_ROOT/tools/production_dispatcher.py}"
DAILY_CODE_HOUR="${DAILY_CODE_HOUR:-14}"
DAILY_CODE_GRACE_MINUTES="${DAILY_CODE_GRACE_MINUTES:-10}"

hour="$(date +%H)"
minute="$(date +%M)"

# 指定した1枠だけDaily Codeへ分岐します。
# 二重投稿防止はrun_daily_code_once.py側のstateで行います。
if [[ "$((10#$hour))" -eq "$((10#$DAILY_CODE_HOUR))"    && "$((10#$minute))" -le "$((10#$DAILY_CODE_GRACE_MINUTES))" ]]; then
    exec "$PYTHON_BIN" "$DAILY_REPO/automation/ubuntu/run_daily_code_once.py"
fi

# それ以外の枠は既存ブログdispatcherへ戻します。
exec "$PYTHON_BIN" "$BLOG_DISPATCHER"
