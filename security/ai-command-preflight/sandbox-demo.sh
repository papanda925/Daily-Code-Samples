#!/usr/bin/env bash
set -euo pipefail

# 実環境ではなく一時ディレクトリで変更系コマンドを試す例です。
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'sample\n' > "$tmpdir/example.txt"

printf 'WORKDIR=%q\n' "$tmpdir"
ls -la "$tmpdir"
printf '\n--- file content ---\n'
cat "$tmpdir/example.txt"
