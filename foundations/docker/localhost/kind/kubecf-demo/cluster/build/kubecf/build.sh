#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating kubecf resource definitions..."
  helm template kubecf "${SCRIPT_DIR}/_vendir/upstream/charts/kubecf" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      >"${SCRIPT_DIR}/../../config/kubecf/_ytt_lib/kubecf/rendered.yml"
  ;;
esac
