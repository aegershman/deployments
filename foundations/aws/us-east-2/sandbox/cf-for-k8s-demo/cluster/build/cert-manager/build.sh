#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating cert-manager resource definitions..."
  ytt --ignore-unknown-comments \
    -f ${SCRIPT_DIR}/_vendir/upstream \
    >"${SCRIPT_DIR}/../../config/cert-manager/_ytt_lib/cert-manager/rendered.yml"
  ;;
esac
