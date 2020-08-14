#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating concourse-web resource definitions..."
  helm template concourse-web --namespace=concourse-web "${SCRIPT_DIR}/_vendir/upstream" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - |
    kbld -f - --lock-output="${SCRIPT_DIR}/_vendir/manual/kbld-lock.yml" \
      >"${SCRIPT_DIR}/../../config/concourse-web/_ytt_lib/concourse-web/rendered.yml"
  ;;
esac
