#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating minibroker resource definitions..."
  helm template minibroker "${SCRIPT_DIR}/_vendir/" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/minibroker/_ytt_lib/minibroker/rendered.yml"
  ;;
esac
