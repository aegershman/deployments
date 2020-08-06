#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating jaeger-operator resource definitions..."
  helm template jaeger-operator "${SCRIPT_DIR}/_vendir/upstream" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/jaeger-operator/_ytt_lib/jaeger-operator/rendered.yml"
  ;;
esac
