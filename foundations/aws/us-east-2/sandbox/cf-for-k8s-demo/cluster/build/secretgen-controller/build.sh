#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating secretgen-controller resource definitions..."
  ytt \
    -f ${SCRIPT_DIR}/_vendir/upstream/release.yml \
    >"${SCRIPT_DIR}/../../config/secretgen-controller/_ytt_lib/secretgen-controller/rendered.yml"
  ;;
esac
