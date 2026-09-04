#!/usr/bin/env bash
set -euo pipefail
ROOT="${POSTBOT_ROOT:-/home/papanda925/new_gemini_postbot}"
DAILY_REPO="${DAILY_CODE_REPO:-/home/papanda925/Daily-Code-Samples}"
PYTHON="${ROOT}/venv/bin/python"
hour="$(date +%H)"
minute="$(date +%M)"
# 14:00枠だけDaily Codeへ。再実行時の二重投稿はPython側のstateで防止。
if [[ "$hour" == "14" && $((10#$minute)) -le 10 ]]; then
  exec "$PYTHON" "$DAILY_REPO/automation/ubuntu/run_daily_code_once.py"
fi
# その他9枠は既存dispatcherをそのまま実行。
exec "$PYTHON" "$ROOT/tools/production_dispatcher.py"
