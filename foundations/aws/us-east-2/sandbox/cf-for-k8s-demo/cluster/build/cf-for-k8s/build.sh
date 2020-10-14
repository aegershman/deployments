#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
clean)
  rm -f "${SCRIPT_DIR}/cf-vars.yaml"
  ;;

generate)
  "${SCRIPT_DIR}"/generate-values.sh --silence-hack-warning --cf-domain cf.gershman.io >"${SCRIPT_DIR}/cf-values-generated.yml"
  ;;

*)
  echo "generating cf-for-k8s resource definitions..."
  ytt \
    -f ${SCRIPT_DIR}/_vendir/upstream/cf-for-k8s/config \
    -f ${SCRIPT_DIR}/cf-app-registry-values.yml \
    -f ${SCRIPT_DIR}/cf-values-generated.yml \
    -f ${SCRIPT_DIR}/cf-values-optional-toggles.yml |
    kbld \
      -f "${SCRIPT_DIR}/_vendir/manual/kbld-istio-proxy-config.yml" \
      -f - --lock-output="${SCRIPT_DIR}/_vendir/manual/kbld-lock.yml" \
      >"${SCRIPT_DIR}/../../config/cf-for-k8s/_ytt_lib/cf-for-k8s/rendered.yml"
  ;;
esac
