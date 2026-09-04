#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

: "${POSTBOT_ROOT:?Set POSTBOT_ROOT before running install.sh.}"
: "${WP_PATH:?Set WP_PATH before running install.sh.}"
: "${TARGET_SERVICE:?Set TARGET_SERVICE to the existing systemd service name.}"

DAILY_CODE_REPO="${DAILY_CODE_REPO:-$REPO_ROOT}"
TARGET_TIMER="${TARGET_TIMER:-}"
ENV_FILE="${DAILY_CODE_ENV_FILE:-/etc/daily-code-wordpress.env}"
PYTHON_BIN="${PYTHON_BIN:-$POSTBOT_ROOT/venv/bin/python}"

if [[ ! "$TARGET_SERVICE" =~ ^[A-Za-z0-9_.@-]+\.service$ ]]; then
    echo "ERROR: TARGET_SERVICE must be a systemd .service name." >&2
    exit 1
fi

if [[ -n "$TARGET_TIMER" && ! "$TARGET_TIMER" =~ ^[A-Za-z0-9_.@-]+\.timer$ ]]; then
    echo "ERROR: TARGET_TIMER must be a systemd .timer name." >&2
    exit 1
fi

if [[ ! -x "$PYTHON_BIN" ]]; then
    echo "ERROR: Python environment not found: $PYTHON_BIN" >&2
    exit 1
fi

if [[ ! -d "$DAILY_CODE_REPO/.git" ]]; then
    echo "ERROR: DAILY_CODE_REPO is not a Git repository: $DAILY_CODE_REPO" >&2
    exit 1
fi

POSTBOT_ROOT="$POSTBOT_ROOT" WP_PATH="$WP_PATH" DAILY_CODE_REPO="$DAILY_CODE_REPO" "$PYTHON_BIN" "$DAILY_CODE_REPO/automation/ubuntu/run_daily_code_once.py" --dry-run

DROPIN_DIR="/etc/systemd/system/$TARGET_SERVICE.d"
DROPIN_FILE="$DROPIN_DIR/daily-code.conf"

sudo mkdir -p "$DROPIN_DIR"

cat <<EOF | sudo tee "$DROPIN_FILE" >/dev/null
[Service]
WorkingDirectory=$POSTBOT_ROOT
EnvironmentFile=-$ENV_FILE
ExecStart=
ExecStart=/bin/bash -lc '$DAILY_CODE_REPO/automation/ubuntu/dispatch_with_daily_code.sh'
EOF

sudo systemctl daemon-reload

if [[ -n "$TARGET_TIMER" ]]; then
    sudo systemctl restart "$TARGET_TIMER"
fi

echo "Installed Daily Code integration."
echo "Service : $TARGET_SERVICE"
echo "Drop-in : $DROPIN_FILE"
echo "Env file: $ENV_FILE"
