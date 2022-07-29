#!/usr/bin/env bash

set -e

case "$1" in
ingress-local)
  exit 1
  kubectl apply -f build/ingress-nginx/namespace.yaml
  helm template ingress-nginx \
    --namespace=ingress-nginx \
    "build/ingress-nginx/_vendir/upstream/charts/ingress-nginx" \
    --values="build/ingress-nginx/values.yml" | kubectl apply -f -
  ;;

delete-ingress)
  kubectl delete -f ./build/ingress-nginx/
  ;;

misc)
  # purely for copy-paste convenience
  exit 1
  helm repo add "stable" "https://charts.helm.sh/stable" --force-update
  ;;

kc | kind-create)
  kind create cluster --config ./kind.config.yaml # --image kindest/node:v1.24.2
  docker exec -it "kind-control-plane" bash -c 'cp /etc/kubernetes/pki/ca.crt /etc/ssl/certs/ && update-ca-certificates && (systemctl list-units | grep containerd > /dev/null && systemctl restart containerd)'
  ;;

kd | kind-delete)
  kind delete cluster
  docker system prune --all --volumes --force
  ;;

*)
  echo "NOTE this script isn't really for direct consumption, go choose an environment"
  exit 1
  ;;
esac
