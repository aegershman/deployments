#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating quarks-secret resource definitions..."
  helm template quarks-secret --namespace=quarks-secret "${SCRIPT_DIR}/_vendir/deploy/helm/quarks-secret" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - |
    kbld -f - >"${SCRIPT_DIR}/../../config/quarks-secret/_ytt_lib/quarks-secret/rendered.yml"
  ;;
esac
