#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
homepage="${root_dir}/index.html"

require_line() {
  local expected="$1"
  if ! grep -Fq -- "$expected" "$homepage"; then
    echo "missing pricing statement: ${expected}" >&2
    exit 1
  fi
}

require_line '$5 trial credit · $50 credit with your first paid month'
require_line 'Your free trial includes <strong>$5 in business credit</strong> and requires no card.'
require_line 'your first paid month includes <strong>$50 in business credit</strong>'

if grep -Eiq '\$50 in free|\$50 (free )?trial|free trial includes <strong>\$50' "$homepage"; then
  echo 'the $50 paid-plan credit is incorrectly described as a trial benefit' >&2
  exit 1
fi

echo "pricing copy guard passed"
