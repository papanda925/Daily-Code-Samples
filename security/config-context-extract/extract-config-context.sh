#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <file> <literal-pattern> [context-lines]" >&2
  exit 2
}

[[ $# -ge 2 && $# -le 3 ]] || usage

file="$1"
pattern="$2"
context="${3:-3}"

[[ -f "$file" ]] || { echo "[FAILED] file not found: $file" >&2; exit 2; }
[[ "$context" =~ ^[0-9]+$ ]] || { echo "[FAILED] context-lines must be 0 or greater" >&2; exit 2; }

echo "[START] 元ファイルは変更せず、必要箇所の前後だけ表示します"
echo "[TARGET] file=$file pattern=$pattern context=$context"
echo

# -F: 正規表現ではなく文字列そのものとして検索
# -n: 元ファイルの行番号を表示
# -B/-A: 一致行の前後だけを表示
result="$(grep -n -F -B "$context" -A "$context" -- "$pattern" "$file" || true)"

if [[ -z "$result" ]]; then
  echo "[FAILED] pattern not found" >&2
  exit 1
fi

printf '%s\n' "$result"

echo
if printf '%s\n' "$result" | grep -Eqi '(password|passwd|secret|token|api[_-]?key|authorization)[[:space:]]*[:=]'; then
  echo "[WARNING] 秘密情報らしい文字列があります。AIへ渡す前に必ずマスクと目視確認をしてください"
else
  echo "[CHECK] 典型的な秘密情報キーは見つかりませんでした。ただし目視確認は省略しないでください"
fi

echo "[SUCCESS] 必要箇所だけを抽出しました。まだ外部共有はしていません"
