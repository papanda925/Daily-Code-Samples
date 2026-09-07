#!/usr/bin/env bash
set -euo pipefail

url="${1:-}"

if [[ -z "$url" ]]; then
  echo "使い方: $0 <URL>" >&2
  echo "例: $0 http://127.0.0.1:8000/not-found" >&2
  exit 2
fi

# -sS:
#   通常の進捗表示は消しつつ、接続失敗などのエラーは表示します。
#
# -D -:
#   レスポンスヘッダーを標準出力へ表示します。
#
# -o /dev/null:
#   本文は捨てて、最初の切り分けに必要な情報へ絞ります。
#
# --connect-timeout / --max-time:
#   調査コマンド自体が長時間待ち続けることを防ぎます。
curl \
  --silent \
  --show-error \
  --location \
  --connect-timeout 5 \
  --max-time 15 \
  --dump-header - \
  --output /dev/null \
  --write-out $'\nHTTP_STATUS=%{http_code}\nREMOTE_IP=%{remote_ip}\nTOTAL_TIME=%{time_total}s\n' \
  "$url"
