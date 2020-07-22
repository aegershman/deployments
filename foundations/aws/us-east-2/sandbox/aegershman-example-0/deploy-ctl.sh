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

cf-for-k8s-delete)
  kapp delete -a cf --yes
  ;;

*)
  exit 1
  ;;
esac
