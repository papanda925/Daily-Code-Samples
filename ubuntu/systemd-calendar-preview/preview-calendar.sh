#!/usr/bin/env bash
# Read-only exploration of systemd OnCalendar schedule. No sudo, no unit write.
set -euo pipefail
if ! command -v systemd-analyze >/dev/null 2>&1; then
  echo "systemd-analyze not installed" >&2; exit 2
fi
expr='${1:-*-*-* 00,02,04,06,08,10,12,14,16,18,20,22:05:00 Asia/Tokyo}'
printf 'Expression: %s\n' "$expr"
systemd-analyze calendar --iterations=8 "$expr"
