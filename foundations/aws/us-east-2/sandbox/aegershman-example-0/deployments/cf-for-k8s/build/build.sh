#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
clean-generated-cf-values)
  rm -f "${SCRIPT_DIR}/../_rendered/cf-vars.yaml"
  ;;

generate-values)
  ./generate-values.sh --silence-hack-warning --cf-domain cf.gershman.io >"${SCRIPT_DIR}/../_rendered/cf-values-generated.yml"
  ;;

*)
  exit 1
  ;;
esac
