#!/usr/bin/env bash

set -e

case "$1" in
kind-create)
  # https://github.com/cloudfoundry-incubator/cf-operator/#prerequisites
  kind create cluster --config ./foundations/docker/localhost/kind/_common/kind.config.yaml # --image kindest/node:v1.17.5
  docker exec -it "kind-control-plane" bash -c 'cp /etc/kubernetes/pki/ca.crt /etc/ssl/certs/ && update-ca-certificates && (systemctl list-units | grep containerd > /dev/null && systemctl restart containerd)'
  ;;

kind-delete)
  kind delete cluster
  docker system prune --all --volumes --force
  ;;

cd)
  # purely for copy-paste convenience
  exit 0
  cd ./foundations/aws/us-east-2/sandbox/cf-for-k8s-demo
  cd ./foundations/docker/localhost/kind/cf-for-k8s-demo
  ;;

*)
  echo "NOTE this script isn't really for direct consumption, go choose an environment"
  exit 1
  ;;
esac
