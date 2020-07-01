#!/usr/bin/env bash

set -euo pipefail

case "$1" in
init)
  # purely for testing at the moment
  exit 1
  chmod +x ./build/_vendir/github.com/kubernetes-sigs/cluster-api/clusterctl-darwin-amd64
  ./build/_vendir/github.com/kubernetes-sigs/cluster-api/clusterctl-darwin-amd64 init --infrastructure aws --list-images
  clusterctl config cluster my-cluster --kubernetes-version v1.16.3 --infrastructure:aws >my-cluster.yaml
  clusterctl config cluster my-cluster --kubernetes-version v1.16.3 --control-plane-machine-count=3 --worker-machine-count=3 >my-cluster.yaml


  clusterctl --config clusterctl.yaml
  ;;

*)
  exit 1
  ;;
esac
