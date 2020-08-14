#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating external-dns resource definitions..."
  helm template external-dns --namespace=external-dns "${SCRIPT_DIR}/_vendir/upstream/bitnami/external-dns" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - |
    kbld -f - --lock-output="${SCRIPT_DIR}/_vendir/manual/kbld-lock.yml" \
      >"${SCRIPT_DIR}/../../config/external-dns/_ytt_lib/external-dns/rendered.yml"
  ;;
esac
