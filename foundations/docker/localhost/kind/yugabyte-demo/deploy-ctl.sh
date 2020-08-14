#!/usr/bin/env bash

set -e

case "$1" in
build)
  for b in ./cluster/build/*; do
    pushd "${b}"
    echo "in ${b}..."
    ./build.sh
    popd
  done
  ;;

a | apply)
  exit 1
  ;;

port-forward)
  kubectl -n yugabyte port-forward svc/yb-masters 7000:7000
  kubectl -n yugabyte port-forward svc/yb-tservers 9042:9042 6379:6379 5433:5433
  ;;

yugabyte-logs)
  exit 1
  kubectl -n yugabyte logs -f -lapp=yb-master --all-containers
  kubectl -n yugabyte logs -f -lapp=yb-tserver --all-containers
  kubectl -n yugabyte logs -f -lchart=yugabyte --all-containers --max-log-requests=10
  ;;

*)
  exit 1
  ;;
esac
