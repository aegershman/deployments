#!/usr/bin/env bash

set -euo pipefail

case "$1" in
clean-generated-cf-values)
  rm -f ../_rendered/cf/cf-vars.yaml
  ;;

generate-values)
  ./generate-values.sh --silence-hack-warning --cf-domain cf.gershman.io >../_rendered/cf/cf-values-generated.yml
  ;;

render)
  ytt \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-resource-requirements.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/add-metrics-server-components.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/patch-metrics-server.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/use-external-dns-for-wildcard.yml \
    -f ../_rendered/cf/cf-values-generated.yml \
    -f ../config/opsfiles/cf-registry-values-ecr.yml \
    >../_rendered/cf/cf-for-k8s-rendered.yml
  ;;

build)
  ./build.sh generate-values
  ./build.sh render
  ;;

*)
  exit 1
  ;;
esac
