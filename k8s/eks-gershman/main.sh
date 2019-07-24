#!/usr/bin/env bash

set -e

case "$1" in
c | create | up) eksctl create cluster -f cluster.yaml ;;
u | update) eksctl update cluster -f cluster.yaml --wait ;;
d | down | delete) eksctl delete cluster -f cluster.yaml --wait ;;

b | bootstrap)
  echo "Ensuring you are targeting the correct kubectl..."
  kubectl config use-context gershman-admin@eks-gershman.us-east-2.eksctl.io

  kubectl apply -f bootstrap/rbac-tiller.yml
  kubectl apply -f bootstrap/storageclass.yml
  helm init --service-account tiller
  ;;

l | login)
  fly -t localhost login -k -c http://concourse.gershman.io -n main -b
  fly -t localhost sync
  ;;

-h | --help | *)
  cat <<-EOF
usage:
  ./main.sh bootstrap
EOF

  exit 1
  ;;
esac
