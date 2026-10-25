#!/usr/bin/env bash
# UbuntuでPHP関連パッケージの状態と版数を見るだけのサンプルです。
# 更新はしません。画面に貼り付けてもターミナルを終了しません。
check_php_packages() {
  local p row policy line installed candidate result=0
  local packages=("$@")
  if (( ${#packages[@]} == 0 )); then
    packages=(php8.3-cli php8.3-fpm php8.3-common)
  fi

  # 入力はパッケージ名だけに限定します（コマンドの混入を防止）。
  for p in "${packages[@]}"; do
    if [[ ! $p =~ ^[a-z0-9][a-z0-9+.-]*(:[a-z0-9][a-z0-9-]*)?$ ]]; then
      echo "[ERROR] パッケージ名が不正です: $p" >&2
      return 2
    fi
  done
  for p in dpkg-query apt-cache; do
    command -v "$p" >/dev/null || { echo "[ERROR] $p がありません" >&2; return 2; }
  done

  echo 'STATE  PACKAGE  VERSION'
  for p in "${packages[@]}"; do
    # installedでない場合、版数が出ても「更新済み」とは判断しません。
    if ! row=$(LC_ALL=C dpkg-query -W -f='${db:Status-Status}\t${binary:Package}\t${Version}\n' "$p" 2>/dev/null); then
      echo "[NOT_FOUND] $p"; result=1; continue
    fi
    echo "$row"
    if [[ $row != installed$'\t'* ]]; then
      echo "[NOTE] $p はインストールされていません"; result=1
    fi

    # APTの候補は画面に表示するだけ。リポジトリURLは出しません。
    if ! policy=$(LC_ALL=C apt-cache policy "$p" 2>/dev/null); then
      echo "[ERROR] $p のAPT情報を取得できません" >&2; result=1; continue
    fi
    installed=0; candidate=0
    while IFS= read -r line; do
      case "$line" in
        *Installed:*) echo "$line"; installed=1 ;;
        *Candidate:*) echo "$line"; candidate=1 ;;
      esac
    done <<< "$policy"
    if (( ! installed || ! candidate )); then
      echo "[ERROR] $p のInstalled/Candidateが不足しています" >&2; result=1
    fi
  done
  echo '[NOTE] これは安全性の自動判定ではありません。公式情報と照合してください。'
  return "$result"  # exitを使わず、結果コードだけを返します。
}
check_php_packages "$@"
