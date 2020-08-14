#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating cf-operator resource definitions..."
  helm template cf-operator "${SCRIPT_DIR}/_vendir/upstream/cf-operator" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/cf-operator/_ytt_lib/cf-operator/rendered.yml"
  ;;
esac
