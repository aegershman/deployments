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

*)
  exit 1
  ;;
esac
