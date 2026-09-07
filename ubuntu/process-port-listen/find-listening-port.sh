#!/usr/bin/env bash
set -euo pipefail

port="${1:-}"

if [[ -z "$port" ]]; then
  echo "Usage: $0 <port>" >&2
  echo "Example: $0 5000" >&2
  exit 2
fi

# ssのフィルター式へ不正な文字列を渡さないよう、
# 1〜65535の整数だけを受け付けます。
if ! [[ "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
  echo "ERROR: port must be an integer from 1 to 65535." >&2
  exit 2
fi

if ! command -v ss >/dev/null 2>&1; then
  echo "ERROR: ss command was not found." >&2
  exit 1
fi

echo "=== TCP LISTEN sockets on port $port ==="

# -l : LISTEN中のsocketだけを表示
# -n : 名前解決せず、IPアドレスとポート番号を数値のまま表示
# -t : TCPだけを表示
# -p : socketを使っているprocess情報も表示
# 一般ユーザーでは他ユーザーのprocess情報が省略される場合があります。
output="$(ss -lntp "sport = :$port" || true)"

if [[ -z "${output//[[:space:]]/}" ]]; then
  echo "No listening TCP socket found on port $port."
  exit 0
fi

printf '%s\n' "$output"

echo
echo "確認ポイント:"
echo "- LISTEN がある       -> 何らかのTCP socketが待受中"
echo "- Local Address:Port -> どのIPで待受しているか"
echo "- users:(...)        -> process/PID。権限によって省略される場合あり"
