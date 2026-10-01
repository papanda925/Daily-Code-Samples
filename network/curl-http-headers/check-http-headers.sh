#!/usr/bin/env bash
set -euo pipefail

url="https://example.com/"
if [[ $# -ge 1 ]]; then
  url="$1"
fi

print_selected_headers() {
  # 本文は捨て、headersだけを表示します。
  # 秘密情報を含むURLをそのまま共有しないでください。
  curl -sS -D - -o /dev/null "$@" |
    grep -Ei '^(HTTP/|content-type:|content-encoding:|content-length:|vary:|cache-control:)'
}

echo "=== 1. 通常の要求 ==="
print_selected_headers "$url"

echo
echo "=== 2. gzipを受け入れる要求 ==="
print_selected_headers -H 'Accept-Encoding: gzip' "$url"

echo
echo "[CHECK] 同じURLで Content-Encoding / Content-Type / Content-Length / Vary の差を確認してください。"
