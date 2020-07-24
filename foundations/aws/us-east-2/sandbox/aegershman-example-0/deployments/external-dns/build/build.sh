#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  exit 1 # TODO just testing for the moment
  echo "generating external-dns resource definitions..."
  helm template external-dns --namespace=external-dns "${SCRIPT_DIR}/_vendir/github.com/bitnami/charts/bitnami/external-dns" \
    --values="${SCRIPT_DIR}/config/helm/values.yml" |
    ytt --ignore-unknown-comments -f - \
      -f "${SCRIPT_DIR}/config/opsfiles/external-dns-ns.yml" \
      >"${SCRIPT_DIR}/../_rendered/external-dns-rendered.yml"
  ;;
esac
