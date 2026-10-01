#!/usr/bin/env bash
set -u

echo "=== 1. PHP-FPM service候補 ==="
systemctl list-units --type=service --all 'php*-fpm.service' --no-pager 2>&1 || true

echo
echo "=== 2. pool設定の listen ==="
grep -RsnE '^[[:space:]]*listen[[:space:]]*=' /etc/php/*/fpm/pool.d 2>/dev/null ||   echo "[INFO] 読めるpool設定からlisten行を取得できませんでした。"

echo
echo "=== 3. Unix socket待受 ==="
if command -v ss >/dev/null 2>&1; then
  ss -lx 2>/dev/null | grep -Ei 'php|fpm|\.sock' ||     echo "[INFO] ss出力からPHP-FPMらしいUnix socketを見つけられませんでした。"
else
  echo "[INFO] ssコマンドがありません。"
fi

echo
echo "=== 4. Nginx FastCGI設定 ==="
if command -v nginx >/dev/null 2>&1; then
  # nginx -Tは設定全体を出すため、ここではFastCGI関連行だけを残します。
  nginx -T 2>&1 | grep -nE 'fastcgi_pass|SCRIPT_FILENAME' ||     echo "[INFO] 読み取れたNginx設定からFastCGI関連行を見つけられませんでした。"
else
  echo "[INFO] nginxコマンドがありません。"
fi

echo
echo "[CHECK] service名、FPMのlisten、実際のsocket、Nginxのfastcgi_passが同じ経路を指すか確認してください。"
echo "[NOTE] このスクリプトは設定変更・reload・restartを行いません。"
