#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
*)
  echo "generating concourse-web resource definitions..."
  ytt --ignore-unknown-comments \
    -f ${SCRIPT_DIR}/_vendir \
    >"${SCRIPT_DIR}/../../config/concourse-web/_ytt_lib/concourse-web/rendered.yml"
  ;;
esac
