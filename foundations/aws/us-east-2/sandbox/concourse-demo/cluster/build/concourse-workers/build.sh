#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating concourse-workers resource definitions..."
  helm template concourse-workers --namespace=concourse-workers "${SCRIPT_DIR}/_vendir/upstream" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - |
    kbld -f - --lock-output="${SCRIPT_DIR}/_vendir/manual/kbld-lock.yml" \
      >"${SCRIPT_DIR}/../../config/concourse-workers/_ytt_lib/concourse-workers/rendered.yml"
  ;;
esac
