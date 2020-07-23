#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating external-dns resource definitions..."
  helm template --namespace=external-dns "${SCRIPT_DIR}/_vendir/external-dns" \
    --values="${SCRIPT_DIR}/../config/helm/values.yml" |
    ytt --ignore-unknown-comments -f - \
      -f "${SCRIPT_DIR}/../config/opsfiles/external-dns-ns.yml" \
      >"${SCRIPT_DIR}/../_rendered/external-dns/external-dns-rendered.yml"
  ;;
esac
