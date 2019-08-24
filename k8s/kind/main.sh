#!/usr/bin/env bash

set -e

case "$1" in

k | kubeconfig)
  export KUBECONFIG="$(kind get kubeconfig-path)"
  kubectl cluster-info
  ;;

b | bootstrap)
  echo "Ensuring you are targeting the correct kubectl..."
  export KUBECONFIG="$(kind get kubeconfig-path)"
  kubectl config use-context kubernetes-admin@kind

  kubectl apply -f bootstrap/rbac-tiller.yml
  helm init --service-account tiller
  ;;

-h | --help | *)
  cat <<-EOF
usage:
  ./main.sh bootstrap
EOF

  exit 1
  ;;
esac
