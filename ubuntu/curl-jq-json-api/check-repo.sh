#!/usr/bin/env bash
set -euo pipefail

repo="${1:-papanda925/Daily-Code-Samples}"
url="https://api.github.com/repos/${repo}"

curl -fsSL "$url" |
  jq '{
    full_name,
    visibility,
    default_branch,
    language,
    updated_at
  }'
