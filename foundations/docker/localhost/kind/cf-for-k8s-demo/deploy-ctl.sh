#!/usr/bin/env bash

set -euo pipefail

case "$1" in
cf-for-k8s-full-install)
  ./deploy-ctl.sh cf-for-k8s-clean-values
  ./deploy-ctl.sh cf-for-k8s-build
  ./deploy-ctl.sh cf-for-k8s-apply
  ;;

cf-for-k8s-clean-values)
  cd ./deployments/cf-for-k8s/build
  ./build.sh clean-generated-cf-values
  ;;

cf-for-k8s-build)
  cd ./deployments/cf-for-k8s/build
  ./build.sh build
  ;;

cf-for-k8s-apply)
  kapp deploy -a cf -f ./deployments/cf-for-k8s/_rendered/cf/cf-for-k8s-rendered.yml --yes
  ;;

harbor-apply)
  :
  ;;

jaeger-operator-apply)
  :
  ;;

minibroker-apply)
  :
  ;;

prometheus-operator-apply)
  :
  ;;

service-catalog-apply)
  :
  ;;

*)
  exit 1
  ;;
esac
