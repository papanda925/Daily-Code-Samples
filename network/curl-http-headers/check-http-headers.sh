#!/usr/bin/env bash
set -euo pipefail

url="${1:-https://example.com/}"

echo "=== HEAD ==="
curl -I "$url"

echo
echo "=== GET headers with gzip accepted ==="
curl -sS -D - -o /dev/null -H 'Accept-Encoding: gzip' "$url"

echo
echo "=== GET with headers and body ==="
curl -i "$url"
