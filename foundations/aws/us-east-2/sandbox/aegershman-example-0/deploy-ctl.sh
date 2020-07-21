#!/usr/bin/env bash

set -euo pipefail

case "$1" in
eksctl-deploy)
  eksctl create cluster -f ./eks-cluster.yaml
  ;;

*)
  exit 1
  ;;
esac
