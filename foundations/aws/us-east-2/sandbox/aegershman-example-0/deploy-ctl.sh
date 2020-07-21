#!/usr/bin/env bash

set -euo pipefail

case "$1" in
eksctl-create)
  eksctl create cluster --config-file=eks-cluster.yaml
  ;;

eksctl-write-kubeconfig)
  eksctl utils write-kubeconfig --region=us-east-2 --cluster=aegershman-example-0 --auto-kubeconfig
  ;;

eksctl-delete)
  eksctl delete cluster -f ./eks-cluster.yaml
  ;;

*)
  exit 1
  ;;
esac
