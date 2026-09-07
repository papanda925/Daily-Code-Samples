#!/usr/bin/env bash
set -euo pipefail

echo "[START] /proc の self と PID を読み比べます"
echo "[SHELL] このBashの PID = $$"

echo
echo "[OBSERVE 1] /proc/$$/status は、このBash自身を指定します"
awk '/^(Name|Pid|PPid):/ {print}' "/proc/$$/status"

echo
echo "[OBSERVE 2] /proc/self/status は『そのファイルを読むプロセス自身』を指します"
echo "下の awk は別プロセスなので、Pid は Bash の $$ と異なるはずです"
awk '/^(Name|Pid|PPid):/ {print}' /proc/self/status

echo
echo "[SUCCESS] /proc/<PID> と /proc/self の違いを観察しました"
echo "[TRY] cat /proc/$$/cmdline | tr '\\0' ' ' を実行し、このBashの起動内容を見てみてください"
