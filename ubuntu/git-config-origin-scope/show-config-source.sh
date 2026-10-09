#!/usr/bin/env bash
# Temporary repo only; do not change real/global/system Git configuration.
set -euo pipefail
temp_dir="$(mktemp -d)"
trap 'rm -rf -- "$temp_dir"' EXIT
export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null

git -C "$temp_dir" init -q
git -C "$temp_dir" config --local user.name "Sample Local"

printf '=== local setting ===\n'
git -C "$temp_dir" config --show-origin --show-scope --get user.name

printf '=== command-line override ===\n'
git -C "$temp_dir" -c user.name="Sample Override" config --show-origin --show-scope --get user.name

printf '=== local-only list ===\n'
git -C "$temp_dir" config --local --list
