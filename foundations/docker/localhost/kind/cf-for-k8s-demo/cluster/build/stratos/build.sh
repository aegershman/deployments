#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating stratos resource definitions..."
  helm template stratos "${SCRIPT_DIR}/_vendir/" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/stratos/_ytt_lib/stratos/rendered.yml"
  ;;
esac
