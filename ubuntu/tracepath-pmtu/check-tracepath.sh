#!/usr/bin/env bash
set -u

TARGET="${1:-example.com}"

if ! command -v tracepath >/dev/null 2>&1; then
  echo "[FAILED] tracepath command not found" >&2
  echo "[HINT] Install the iputils package for your distribution." >&2
  exit 2
fi

echo "[INFO] target=$TARGET"
echo "[INFO] hostnames enabled"
tracepath "$TARGET"

echo
echo "[INFO] numeric output"
tracepath -n "$TARGET"
