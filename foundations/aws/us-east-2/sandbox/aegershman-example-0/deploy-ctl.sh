#!/usr/bin/env bash

set -e

case "$1" in
eksc | eksctl-create) eksctl create cluster --config-file=eks-cluster.yaml ;;
eksctl-write-kubeconfig) eksctl utils write-kubeconfig --region=us-east-2 --cluster=aegershman-example-0 --auto-kubeconfig ;;
eksd | eksctl-delete) eksctl delete cluster -f ./eks-cluster.yaml ;;

build)
  shift
  case "${1}" in
  ed | external-dns)
    pushd ./cluster/build/external-dns
    ./build.sh
    popd
    ;;
  h | harbor)
    pushd ./cluster/build/harbor
    ./build.sh
    popd
    ;;
  cf | cf-for-k8s)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh
    popd
    ;;
  all)
    for b in ./cluster/build/*; do
      pushd "${b}"
      echo "in ${b}..."
      ./build.sh
      popd
    done
    ;;
  *)
    echo "usage: ./deploy.sh build all"
    echo "usage: ./deploy.sh build <kapp-env>"
    echo "example: ./deploy-ctl.sh build harbor"
    echo "example: ./deploy-ctl.sh build all"
    exit 1
    ;;
  esac
  ;;

a | apply | deploy)
  shift
  case "${1}" in
  ed | external-dns)
    shift
    kapp deploy -a external-dns -f <(ytt -f ./cluster/config/external-dns/) "$@"
    ;;
  h | harbor)
    shift
    kapp deploy -a harbor -f <(ytt -f ./cluster/config/harbor/) "$@"
    ;;
  cf | cf-for-k8s)
    shift
    kapp deploy -a cf -f ./cluster/config/cf-for-k8s/_ytt_lib/cf-for-k8s/rendered.yml "$@"
    ;;
  *)
    echo "usage: ./deploy.sh apply <kapp-env> [optional-args...]"
    echo "example: ./deploy-ctl.sh apply cf --yes"
    exit 1
    ;;
  esac
  ;;

d | delete)
  shift
  case "${1}" in
  ed | external-dns)
    shift
    kapp delete -a external-dns "$@"
    ;;
  h | harbor)
    shift
    kapp delete -a harbor "$@"
    ;;
  cf | cf-for-k8s)
    shift
    kapp delete -a cf "$@"
    ;;
  *)
    echo "usage: ./deploy.sh delete <kapp-env> [optional-args...]"
    echo "example: ./deploy-ctl.sh delete harbor --yes"
    exit 1
    ;;
  esac
  ;;

pi | cf-for-k8s-post-install)
  cf api --skip-ssl-validation https://api.cf.gershman.io
  cf auth admin $(yq r ./cluster/build/cf-for-k8s/cf-values-generated.yml 'cf_admin_password')
  cf target
  cf enable-feature-flag diego_docker
  cf create-org test-org
  cf create-space -o test-org test-space
  cf target -o test-org -s test-space
  ;;

pip | cf-for-k8s-post-install-push)
  # push an app already built via docker
  cf push -f ./cluster/config-optional/cf-manifests/hash-browns-docker-no-routes.yml --strategy=rolling
  cf push -f ./cluster/config-optional/cf-manifests/hash-browns-docker-routes.yml --strategy=rolling
  cf push -f ./cluster/config-optional/cf-manifests/todo-ui-docker-routes.yml --strategy=rolling

  # push an app from source code
  exit 0
  cf push test-node-app -p ./cluster/build/cf-for-k8s/_vendir/cf-for-k8s/tests/smoke/assets/test-node-app
  curl http://test-node-app.apps.cf.gershman.io/env
  ;;

cf-for-k8s-kpack-ecr-debug)
  exit 1
  # aws ecr get-login-password --region us-east-2
  kubectl -n cf-workloads-staging describe images
  kubectl -n cf-workloads-staging describe CustomBuilder
  ;;

*)
  exit 1
  ;;
esac
