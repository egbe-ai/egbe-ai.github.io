#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
homepage="${root_dir}/index.html"

test "$(grep -Fc '$5 in free business credit' "$homepage")" = "2"
if grep -Eq '\$50[^<]*(usage|business) credit' "$homepage"; then
  echo 'stale $50 trial-credit claim found' >&2
  exit 1
fi

echo "pricing copy guard passed"
