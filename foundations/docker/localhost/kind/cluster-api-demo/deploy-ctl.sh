#!/usr/bin/env bash

set -euo pipefail

case "$1" in
*)
  # https://cluster-api.sigs.k8s.io/clusterctl/commands/config-cluster.html
  # https://cluster-api.sigs.k8s.io/clusterctl/developers.html#additional-steps-in-order-to-use-the-docker-provider
  exit 1
  ;;
esac
