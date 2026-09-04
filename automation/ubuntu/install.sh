#!/usr/bin/env bash
set -euo pipefail
POSTBOT_ROOT="${POSTBOT_ROOT:-/home/papanda925/new_gemini_postbot}"
DAILY_CODE_REPO="${DAILY_CODE_REPO:-/home/papanda925/Daily-Code-Samples}"
if [[ ! -d "$POSTBOT_ROOT" || ! -x "$POSTBOT_ROOT/venv/bin/python" ]]; then
  echo "ERROR: new_gemini_postbot または venv が見つかりません" >&2
  exit 1
fi
if [[ ! -d "$DAILY_CODE_REPO/.git" ]]; then
  git clone git@github.com:papanda925/Daily-Code-Samples.git "$DAILY_CODE_REPO"
else
  git -C "$DAILY_CODE_REPO" pull --ff-only origin main
fi
"$POSTBOT_ROOT/venv/bin/python" "$DAILY_CODE_REPO/automation/ubuntu/run_daily_code_once.py" --dry-run
sudo mkdir -p /etc/systemd/system/gemini_postbot_auto_post.service.d
cat <<EOF | sudo tee /etc/systemd/system/gemini_postbot_auto_post.service.d/daily-code.conf >/dev/null
[Service]
WorkingDirectory=$POSTBOT_ROOT
ExecStart=
ExecStart=/bin/bash -lc '$DAILY_CODE_REPO/automation/ubuntu/dispatch_with_daily_code.sh'
Environment=POSTBOT_ROOT=$POSTBOT_ROOT
Environment=DAILY_CODE_REPO=$DAILY_CODE_REPO
Environment=DAILY_CODE_WP_STATUS=publish
EOF
sudo systemctl daemon-reload
sudo systemctl restart gemini_postbot_auto_post.timer
echo "Daily Code 14:00 slot installed."
