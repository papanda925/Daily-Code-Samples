#!/usr/bin/env bash
# PHP関連パッケージの状態と版数を確認する教材。
# パッケージ更新・サービス操作・脆弱性の自動判定は行わない。
set -u

packages=("$@")
if (( ${#packages[@]} == 0 )); then
  packages=(php8.3-cli php8.3-fpm php8.3-common)
fi

# オプション・ワイルドカード・シェル式をパッケージ名として渡さない。
# すべてを先に確認し、入力に誤りがあれば照会を始めず終了する。
for package in "${packages[@]}"; do
  if [[ ! "$package" =~ ^[a-z0-9][a-z0-9+.-]*(:[a-z0-9][a-z0-9-]*)?$ ]]; then
    printf '%s\n' '[ERROR] パッケージ名の形式が不正です。' >&2
    exit 2
  fi
done

for tool in dpkg-query apt-cache; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf '[ERROR] 必要なコマンドがありません: %s\n' "$tool" >&2
    exit 2
  fi
done

result=0
printf '%s\n' 'STATE  PACKAGE  VERSION'

for package in "${packages[@]}"; do
  # 状態欄を付け、削除済みパッケージの残存版数を適用済みと誤認しない。
  if ! information=$(LC_ALL=C dpkg-query -W \
      -f='${db:Status-Status}\t${binary:Package}\t${Version}\n' \
      "$package" 2>/dev/null); then
    printf '[NOT_FOUND] %s\n' "$package"
    result=1
    continue
  fi
  printf '%s\n' "$information"
  state="${information%%$'\t'*}"
  if [[ "$state" != installed ]]; then
    printf '[NOTE] %s はインストール済み状態ではありません。\n' "$package"
    result=1
  fi

  # APTの候補はローカルキャッシュの情報。更新・ネットワーク取得はしない。
  # リポジトリURL等は出さず、Installed/Candidateの行だけ表示する。
  if ! policy=$(LC_ALL=C apt-cache policy "$package" 2>/dev/null); then
    printf '[ERROR] APTの候補情報を取得できません: %s\n' "$package" >&2
    result=1
    continue
  fi
  found_installed=0
  found_candidate=0
  while IFS= read -r line; do
    case "$line" in
      *Installed:*) printf '%s\n' "$line"; found_installed=1 ;;
      *Candidate:*) printf '%s\n' "$line"; found_candidate=1 ;;
    esac
  done <<< "$policy"
  if (( ! found_installed || ! found_candidate )); then
    printf '[ERROR] APTのInstalled/Candidateが揃いません: %s\n' "$package" >&2
    result=1
  fi
done

printf '%s\n' '[NOTE] 完了は安全性の判定ではありません。OS・配布元の公式通知と照合してください。'
exit "$result"
