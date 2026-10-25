#!/usr/bin/env bash
# PHPパッケージの状態・版数を確認する読み取り専用教材。
# 結果はユーザー専用ローカルファイルに保存する（端末が閉じても再確認可能）。
# ※ターミナルへ直接貼り付けても閉じないよう、トップレベルで exit / set -u を使わない。

php_package_status_main() (
  set -u  # subshell内だけに作用。貼り付け先の対話シェル設定を変更しない。

  local packages=("$@") package tool information state policy line
  local found_installed found_candidate result=0
  if (( ${#packages[@]} == 0 )); then
    packages=(php8.3-cli php8.3-fpm php8.3-common)
  fi

  # 不正な入力は外部コマンドの実行前にすべて拒否する。
  for package in "${packages[@]}"; do
    if [[ ! "$package" =~ ^[a-z0-9][a-z0-9+.-]*(:[a-z0-9][a-z0-9-]*)?$ ]]; then
      printf '%s\n' '[ERROR] パッケージ名の形式が不正です。' >&2
      return 2
    fi
  done
  for tool in dpkg-query apt-cache; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      printf '[ERROR] 必要なコマンドがありません: %s\n' "$tool" >&2
      return 2
    fi
  done

  printf '%s\n' 'STATE  PACKAGE  VERSION'
  for package in "${packages[@]}"; do
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

    # APTローカルキャッシュのみ。リポジトリURLや機密値は表示しない。
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
  return "$result"
)

php_package_status_run() (
  # 別プロセスにし、対話シェルへオプション・umask・変数変更を残さない。
  set -u
  umask 077
  local state_root="${XDG_STATE_HOME:-${HOME:-}/.local/state}"
  local dir log="" filename stamp attempt line result
  if [[ "$state_root" != /* ]]; then
    printf '%s\n' '[ERROR] 結果保存先には絶対パスが必要です。XDG_STATE_HOMEまたはHOMEを確認してください。' >&2
    return 2
  fi
  dir="${state_root}/daily-code-samples/php-package-status"
  if [[ -L "$dir" ]] || ! /bin/mkdir -p -m 700 -- "$dir" || [[ -L "$dir" ]]; then
    printf '%s\n' '[ERROR] 結果保存用フォルダーを安全に作成できません。' >&2
    return 2
  fi
  printf -v stamp '%(%Y%m%dT%H%M%S)T' -1
  for attempt in 1 2 3 4 5 6 7 8; do
    filename="${dir}/php-package-status-${stamp}-${BASHPID}-${RANDOM}-${attempt}.log"
    if ( set -C; : > "$filename" ) 2>/dev/null; then
      log="$filename"
      break
    fi
  done
  if [[ -z "$log" ]]; then
    printf '%s\n' '[ERROR] 結果保存ファイルを作成できません。' >&2
    return 2
  fi

  # 先に保存。端末を自動で閉じるランチャーからでも、結果はログに残る。
  if php_package_status_main "$@" > "$log" 2>&1; then
    result=0
  else
    result=$?
  fi
  printf '[EXIT_CODE] %d\n' "$result" >> "$log"

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      '[ERROR]'*) printf '%s\n' "$line" >&2 ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < "$log"
  printf '[RESULT_FILE] %s\n' "$log"
  printf '[REOPEN] cat -- %q\n' "$log"
  return "$result"
)

# 保存済み結果は ~/.local/state/daily-code-samples/php-package-status/ に残る。
# 末尾の exit は置かない。全文を貼り付けてもログインシェルを閉じない。
php_package_status_run "$@"
