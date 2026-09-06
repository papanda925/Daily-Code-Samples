#!/usr/bin/env bash

# set -e
#   途中のコマンドが失敗したら、その時点でスクリプトを終了します。
#
# set -u
#   未定義の変数を使った場合にエラーにします。
#
# set -o pipefail
#   curl | jq の途中で curl 側だけ失敗した場合も、
#   パイプ全体を失敗として扱えるようにします。
#
# API確認スクリプトでは「失敗したのに続行した」を減らすために有効です。
set -euo pipefail

# 第1引数があれば、その owner/repository を使います。
# 引数がない場合は、学習用の既定値を使います。
#
# 例:
#   ./check-repo.sh openai/openai-python
repo="${1:-papanda925/Daily-Code-Samples}"

# GitHub REST APIのRepository取得URLを組み立てます。
# ここでは認証不要で読める公開Repository APIを使います。
url="https://api.github.com/repos/${repo}"

# curl:
#   -f  HTTP 4xx/5xx をエラー扱いにする
#   -s  通常の進捗メーターを表示しない
#   -S  -s と組み合わせてもエラー内容は表示する
#   -L  リダイレクトがあれば追従する
#
# curl が返したJSONを、そのまま jq へパイプで渡します。
curl -fsSL "$url" |

  # jq はJSONを読みやすく加工するコマンドです。
  # { ... } と書くと、元JSONから必要な項目だけを取り出した
  # 新しいJSONオブジェクトを作れます。
  jq '{
    full_name,
    visibility,
    default_branch,
    language,
    updated_at
  }'
