#!/usr/bin/env bash
set -euo pipefail

# このスクリプトはNginx設定を「確認するだけ」です。
# reloadは自動実行しません。設定テストが失敗した状態で
# サービスへ反映してしまう事故を避けるためです。

dump_config=false

case "${1:-}" in
  "") ;;
  --dump) dump_config=true ;;
  -h|--help)
    echo "Usage: $0 [--dump]"
    echo "  --dump  nginx -T で読み込まれる設定全体も表示します。"
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 2
    ;;
esac

if ! command -v nginx >/dev/null 2>&1; then
  echo "ERROR: nginx command was not found." >&2
  exit 1
fi

echo "=== 1. nginx configuration test ==="

# -t は構文だけでなく、設定から参照されるファイルを開けるかも確認します。
# 権限の都合で一般ユーザーでは失敗する環境があるため、
# 失敗した場合も勝手にsudoせず、利用者へ次の確認方法だけを示します。
if ! nginx -t; then
  echo >&2
  echo "Configuration test failed." >&2
  echo "権限不足が疑われる場合は、内容を確認して sudo nginx -t を試してください。" >&2
  echo "設定エラーが残っている間はreloadしないでください。" >&2
  exit 1
fi

echo
echo "OK: nginx -t succeeded."
echo "reloadはまだ実行していません。"

if "$dump_config"; then
  echo
  echo "=== 2. effective configuration dump ==="
  echo "WARNING: nginx -T の出力には運用情報が含まれる可能性があります。"
  echo
  # -T は -t と同じテストに加え、読み込まれる設定全体を表示します。
  nginx -T
fi
