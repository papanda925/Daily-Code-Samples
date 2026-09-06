#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <config-file>" >&2
  exit 2
fi

input=$1
if [[ ! -f "$input" ]]; then
  echo "ERROR: file not found: $input" >&2
  exit 2
fi

output="${input}.masked"
if [[ -e "$output" ]]; then
  echo "ERROR: output already exists: $output" >&2
  exit 3
fi

umask 077
tmp=$(mktemp "${output}.tmp.XXXXXX")
trap 'rm -f "$tmp"' EXIT

awk '
BEGIN { in_private_key = 0 }
{
  line = $0

  if (line ~ /-----BEGIN ([A-Z0-9 ]+ )?PRIVATE KEY-----/) {
    print line
    print "****"
    in_private_key = 1
    next
  }

  if (in_private_key) {
    if (line ~ /-----END ([A-Z0-9 ]+ )?PRIVATE KEY-----/) {
      print line
      in_private_key = 0
    }
    next
  }

  gsub(/:\/\/[^\/:@[:space:]]+:[^@\/[:space:]]+@/, "://****:****@", line)

  lower = tolower(line)
  if (lower ~ /^[[:space:]]*(export[[:space:]]+)?[a-z0-9_.-]*(password|passwd|token|api[_-]?key|secret|client[_-]?secret|access[_-]?key)[a-z0-9_.-]*[[:space:]]*[:=]/) {
    eq = index(line, "=")
    co = index(line, ":")

    if (eq == 0) sep = co
    else if (co == 0) sep = eq
    else if (eq < co) sep = eq
    else sep = co

    print substr(line, 1, sep) " ****"
    next
  }

  print line
}
' "$input" > "$tmp"

chmod 600 "$tmp"
mv "$tmp" "$output"
trap - EXIT

printf 'Created: %s\n' "$output"
