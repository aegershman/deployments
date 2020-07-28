#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating service-catalog resource definitions..."
  helm template service-catalog "${SCRIPT_DIR}/_vendir/" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/service-catalog/_ytt_lib/service-catalog/rendered.yml"
  ;;
esac
