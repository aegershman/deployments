#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating yugabyte resource definitions..."
  helm template yugabyte "${SCRIPT_DIR}/_vendir/upstream/stable/yugabyte" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/yugabyte/_ytt_lib/yugabyte/rendered.yml"
  ;;
esac
