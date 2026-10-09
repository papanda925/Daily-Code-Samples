#!/usr/bin/env bash
# 読み取り専用: 2種類のAccept-Encodingで同じURLのHTTP応答ヘッダーを比較する。
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf '使い方: %s http://127.0.0.1:8080/index.html\n' "$0" >&2
  exit 2
fi
url=$1
case "$url" in
  http://*|https://*) ;;
  *) printf 'ERROR: http:// または https:// のURLを指定してください\n' >&2; exit 2 ;;
esac
# 認証情報やトークンをURLへ埋め込む事故を避ける。
if [[ "$url" == *'@'* || "$url" == *'?'* || "$url" == *'#'* ]]; then
  printf 'ERROR: @, ?, # を含むURLは使用しないでください\n' >&2
  exit 2
fi
command -v curl >/dev/null || { printf 'ERROR: curlが見つかりません\n' >&2; exit 2; }

inspect() {
  local encoding=$1
  printf '\n=== Accept-Encoding: %s ===\n' "$encoding"
  # HEADではなくGETを使う。本文は保存せず破棄し、必要なヘッダーだけ表示する。
  # リダイレクトを追わず、URLに認証情報を付けず、公開可能な結果だけを残す。
  curl --silent --show-error --http1.1 --proto '=http,https' \
    --max-time 15 --max-redirs 0 \
    --header "Accept-Encoding: $encoding" \
    --dump-header - --output /dev/null -- "$url" |
    awk '{ lower=tolower($0); if (lower ~ /^http\// || lower ~ /^(content-type|content-encoding|content-length|transfer-encoding|vary):/) { sub(/\r$/, ""); print } }'
}
inspect gzip
inspect identity
printf '\nDONE: Content-EncodingとContent-Typeを比較してください。\n'
