#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating external-dns resource definitions..."
  ytt --ignore-unknown-comments \
    -f ${SCRIPT_DIR}/_vendir \
    >"${SCRIPT_DIR}/../../config/external-dns/_ytt_lib/external-dns/rendered.yml"
  ;;
esac
