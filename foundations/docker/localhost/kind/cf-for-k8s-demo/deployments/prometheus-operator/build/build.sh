#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
build)
  helm template prometheus-operator --namespace=prometheus-operator \
    "${SCRIPT_DIR}/_vendir/github.com/helm/charts/prometheus-operator/stable/prometheus-operator/" \
    --values "${SCRIPT_DIR}/values.yml" "${SCRIPT_DIR}/_vendir/stable/prometheus-operator/"
  ;;

*)
  :
  ;;
esac
