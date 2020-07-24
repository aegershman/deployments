#!/usr/bin/env bash

set -euo pipefail

case "$1" in

clean-generated-cf-values) rm -f ../_rendered/cf/cf-vars.yaml ;;
generate-values) ./generate-values.sh --silence-hack-warning --cf-domain cf.gershman.io >../_rendered/cf/cf-values-generated.yml ;;

build)
  # TODO
  ./build.sh generate-values
  ;;

*)
  exit 1
  ;;
esac
