#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  exit 0 # TODO
  echo "generating prometheus-operator resource definitions..."
  helm template prometheus-operator --namespace=prometheus-operator "${SCRIPT_DIR}/_vendir/stable/prometheus-operator" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      -f "${SCRIPT_DIR}/prometheus-operator-namespace.yml" \
      >"${SCRIPT_DIR}/../../config/prometheus-operator/_ytt_lib/prometheus-operator/rendered.yml"
  ;;
esac