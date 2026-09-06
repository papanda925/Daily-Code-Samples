#!/usr/bin/env bash
set -euo pipefail

service_name="${1:-nginx}"

echo "=== status ==="
systemctl status "$service_name" --no-pager || true

echo
echo "=== active / enabled ==="
systemctl is-active "$service_name" || true
systemctl is-enabled "$service_name" || true

echo
echo "=== recent journal ==="
journalctl -u "$service_name" --no-pager -n 80

echo
echo "=== unit definition ==="
systemctl cat "$service_name"

echo
echo "=== key properties ==="
systemctl show "$service_name" \
  -p FragmentPath \
  -p DropInPaths \
  -p ActiveState \
  -p SubState \
  -p Result \
  -p ExecMainStatus
