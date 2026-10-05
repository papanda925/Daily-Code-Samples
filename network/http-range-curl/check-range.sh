#!/usr/bin/env bash
set -u

URL="${1:-}"
RANGE="${2:-0-99}"

if [[ -z "$URL" ]]; then
  echo "Usage: $0 <url> [byte-range]" >&2
  exit 2
fi

echo "[INFO] HEAD request"
curl --fail --silent --show-error --location --head "$URL"

echo
echo "[INFO] Range request: bytes=$RANGE"
curl --fail --silent --show-error --location   --range "$RANGE"   --dump-header -   --output /dev/null   "$URL"
