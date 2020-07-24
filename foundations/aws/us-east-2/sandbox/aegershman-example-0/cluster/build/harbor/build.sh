#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating harbor resource definitions..."
  helm template harbor "${SCRIPT_DIR}/_vendir/harbor-helm" \
    --values="${SCRIPT_DIR}/helm-values.yml" |
    ytt --ignore-unknown-comments -f - \
      -f "${SCRIPT_DIR}/namespace.yml" \
      >"${SCRIPT_DIR}/../../config/harbor/_ytt_lib/harbor/rendered.yml"
  ;;
esac
