#!/usr/bin/env bash
set -u

LOCK_FILE="${1:-/tmp/papanda-flock-demo.lock}"
HOLD_SECONDS="${2:-5}"

if ! command -v flock >/dev/null 2>&1; then
  echo "[FAILED] flock command not found" >&2
  exit 2
fi

echo "[INFO] trying lock: $LOCK_FILE"
if flock -n "$LOCK_FILE" bash -c '
  echo "[SUCCESS] lock acquired"
  echo "[INFO] holding lock for '"$HOLD_SECONDS"' seconds"
  sleep '"$HOLD_SECONDS"'
  echo "[INFO] releasing lock"
'; then
  exit 0
else
  echo "[BLOCKED] another process owns the lock"
  exit 1
fi
