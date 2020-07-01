#!/usr/bin/env bash

set -euo pipefail

case "$1" in
init)
  # https://cluster-api.sigs.k8s.io/clusterctl/commands/config-cluster.html
  # https://cluster-api.sigs.k8s.io/clusterctl/developers.html#additional-steps-in-order-to-use-the-docker-provider
  # https://github.com/k14s/vendir
  ./build/_vendir/github.com/kubernetes-sigs/cluster-api/components/clusterctl-darwin-amd64 init --infrastructure aws --list-images
  ;;

*)
  exit 1
  ;;
esac
