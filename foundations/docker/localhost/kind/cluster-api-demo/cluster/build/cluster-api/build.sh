#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "$1" in
do)
  # purely for testing at the moment
  exit 1
  chmod +x ./build/_vendir/upstream/github.com/kubernetes-sigs/cluster-api/clusterctl-darwin-amd64
  ./build/_vendir/upstream/github.com/kubernetes-sigs/cluster-api/clusterctl-darwin-amd64 init --infrastructure aws --list-images
  clusterctl config cluster my-cluster --kubernetes-version v1.16.3 --infrastructure:aws >my-cluster.yaml
  clusterctl config cluster my-cluster --kubernetes-version v1.16.3 --control-plane-machine-count=3 --worker-machine-count=3 >my-cluster.yaml

  clusterctl --config clusterctl.yaml
  ;;

*)
  exit 1
  ;;
esac
