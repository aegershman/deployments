#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating ingress-nginx resource definitions..."
  helm template ingress-nginx --namespace=ingress-nginx "${SCRIPT_DIR}/_vendir/upstream/charts/ingress-nginx" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - |
    kbld -f - --lock-output="${SCRIPT_DIR}/_vendir/manual/kbld-lock.yml" \
      >"${SCRIPT_DIR}/../../config/ingress-nginx/_ytt_lib/ingress-nginx/rendered.yml"
  ;;
esac
