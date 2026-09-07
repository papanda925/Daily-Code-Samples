#!/usr/bin/env bash
set -euo pipefail

# 本番ファイルを触らず、必ず一時ディレクトリだけで権限変更を試す。
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

demo_file="$work_dir/demo.txt"
printf 'papanda permission demo\n' > "$demo_file"

show_mode() {
  local label="$1"
  printf '\n[%s]\n' "$label"
  # %a は8進数の権限、%A は rwxr-xr-x のような見た目。
  stat --format='numeric=%a symbolic=%A file=%n' "$demo_file"
}

echo "[START] 一時ファイルだけで chmod を試します"
show_mode "INITIAL"

chmod 600 "$demo_file"
show_mode "chmod 600"

chmod 644 "$demo_file"
show_mode "chmod 644"

chmod 755 "$demo_file"
show_mode "chmod 755"

echo
echo "[SUCCESS] 600 / 644 / 755 の変化を確認できました"
echo "[TRY] chmod 640 \"$demo_file\" に変えると何が変わるか予想してから試してください"
