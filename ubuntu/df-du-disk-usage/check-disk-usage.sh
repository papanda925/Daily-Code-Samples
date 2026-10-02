#!/usr/bin/env bash
set -u
TARGET="${1:-$HOME}"
if [ ! -e "$TARGET" ]; then echo "[FAILED] target not found: $TARGET" >&2; exit 1; fi
echo "[START] filesystem usage"
df -h "$TARGET" || { echo "[FAILED] df" >&2; exit 1; }
echo
echo "[START] directory usage"
if du -sh "$TARGET"; then echo "[SUCCESS] df and du completed"; else echo "[FAILED] du could not read all content" >&2; exit 1; fi
