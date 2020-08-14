#!/usr/bin/env bash

set -e

case "$1" in
do)
  # https://cluster-api.sigs.k8s.io/clusterctl/commands/config-cluster.html
  # https://cluster-api.sigs.k8s.io/clusterctl/developers.html#additional-steps-in-order-to-use-the-docker-provider
  exit 1
  chmod +x ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64
  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 -h
  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 config -h
  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 --config ./deployments/cluster-api/build/clusterctl.yaml config repositories
  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 --config ./deployments/cluster-api/build/clusterctl.yaml config provider --infrastructure aws -o yaml
  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 -v5 --config ./deployments/cluster-api/build/clusterctl.yaml config provider --infrastructure aws -o yaml

  ./deployments/cluster-api/build/_vendir/cluster-api/clusterctl-darwin-amd64 -v5 --config ./deployments/cluster-api/build/clusterctl.yaml config provider --infrastructure aws -o yaml
  ;;
esac
