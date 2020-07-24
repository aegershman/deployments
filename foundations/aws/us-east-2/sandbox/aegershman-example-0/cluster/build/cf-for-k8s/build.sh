#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
clean)
  rm -f "${SCRIPT_DIR}/cf-vars.yaml"
  ;;

generate-values)
  "${SCRIPT_DIR}"/generate-values.sh --silence-hack-warning --cf-domain cf.gershman.io >"${SCRIPT_DIR}/cf-values-generated.yml"
  ;;

*)
  echo "generating cf-for-k8s resource definitions..."
  ytt \
    -f ${SCRIPT_DIR}/_vendir/github.com/cloudfoundry/cf-for-k8s/config \
    -f ${SCRIPT_DIR}/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-resource-requirements.yml \
    -f ${SCRIPT_DIR}/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/add-metrics-server-components.yml \
    -f ${SCRIPT_DIR}/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/patch-metrics-server.yml \
    -f ${SCRIPT_DIR}/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/use-external-dns-for-wildcard.yml \
    -f ${SCRIPT_DIR}/cf-values-generated.yml \
    -f ${SCRIPT_DIR}/cf-registry-values-harbor.yml \
    >"${SCRIPT_DIR}/../../config/cf-for-k8s/_ytt_lib/cf-for-k8s/rendered.yml"
  ;;
esac