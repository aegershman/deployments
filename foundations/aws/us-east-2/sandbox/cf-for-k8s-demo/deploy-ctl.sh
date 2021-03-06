#!/usr/bin/env bash

set -e

case "$1" in
eksc | eksctl-create) eksctl create cluster --config-file=eks-cluster.yaml ;;
eksctl-write-kubeconfig) eksctl utils write-kubeconfig --region=us-east-2 --cluster=cf-for-k8s-demo --auto-kubeconfig ;;
eksd | eksctl-delete) eksctl delete cluster -f ./eks-cluster.yaml ;;

build)
  shift
  case "${1}" in
  cm | cert-manager)
    pushd ./cluster/build/cert-manager
    ./build.sh
    popd
    ;;
  cf | cf-for-k8s)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh
    popd
    ;;
  cfr | cf-regenerate-values)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh clean
    ./build.sh generate
    popd
    ;;
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
  qs | quarks-secret)
    pushd ./cluster/build/quarks-secret
    ./build.sh
    popd
    ;;
  sc | secretgen-controller)
    pushd ./cluster/build/secretgen-controller
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
    echo "example: ./deploy-ctl.sh build all"
    echo "usage: ./deploy.sh build {kapp-env}"
    echo "example: ./deploy-ctl.sh build harbor"
    echo "usage: ./deploy-ctl.sh build {cfr, cf-regenerate-values}"
    echo "example: ./deploy.sh build cf-regenerate-values"
    exit 1
    ;;
  esac
  ;;

a | apply | deploy)
  shift
  case "${1}" in
  cm | cert-manager)
    shift
    kapp deploy -a cert-manager -f <(
      ytt --ignore-unknown-comments \
        -f ./cluster/config/cert-manager/ \
        -f ./cluster/config-optional/cert-manager/cert-manager-letsencrypt-prod.yml \
        -f ./cluster/config-optional/cert-manager/cert-manager-letsencrypt-staging.yml
    ) "$@"
    ;;
  cf | cf-for-k8s)
    shift
    kapp deploy -a cf -f <(
      ytt \
        -f ./cluster/config/cf-for-k8s/ \
        -f ./cluster/config-optional/cf-for-k8s/cf-system-certificate-cert-manager-prod.yml \
        -f ./cluster/config-optional/cf-for-k8s/cf-workloads-certificate-cert-manager-prod.yml \
        -f ./cluster/config-optional/cf-for-k8s/istio-ingressgateway-aws-nlb.yml
    ) "$@"
    # -f ./cluster/config-optional/cf-for-k8s/label-ns-quarks-secret-monitor.yml
    # -f ./cluster/config-optional/cf-for-k8s/system-certificate-cert-manager-staging.yml
    ;;
  ed | external-dns)
    shift
    kapp deploy -a external-dns -f <(
      ytt \
        -f ./cluster/config/external-dns/
    ) "$@"
    ;;
  h | harbor)
    shift
    kapp deploy -a harbor -f <(
      ytt \
        -f ./cluster/config/harbor/ \
        -f ./cluster/config-optional/harbor/harbor-cert-manager-prod.yml
    ) "$@"
    # -f ./cluster/config-optional/harbor/label-ns-quarks-secret-monitor.yml
    ;;
  qs | quarks-secret)
    shift
    kapp deploy -a quarks-secret -f <(
      ytt \
        -f ./cluster/config/quarks-secret/ \
        -f ./cluster/config-optional/quarks-secret/example-certificate-signed-from-cluster-ca.yml \
        -f ./cluster/config-optional/quarks-secret/example-password.yml
    ) "$@"
    ;;
  sc | secretgen-controller)
    shift
    kapp deploy -a secretgen-controller -f <(
      ytt \
        -f ./cluster/config/secretgen-controller/ \
        -f ./cluster/config-optional/secretgen-controller/example-password.yml
    ) "$@"
    ;;
  all)
    shift
    ./deploy-ctl.sh apply external-dns "$@"
    ./deploy-ctl.sh apply secretgen-controller "$@"
    ./deploy-ctl.sh apply quarks-secret "$@"
    ./deploy-ctl.sh apply cert-manager "$@"
    ./deploy-ctl.sh apply harbor "$@"
    ./deploy-ctl.sh apply cf-for-k8s "$@"
    ;;
  *)
    echo "usage: ./deploy.sh apply all [optional-args...]"
    echo "usage: ./deploy.sh apply {kapp-env} [optional-args...]"
    echo "example: ./deploy-ctl.sh apply cf --yes"
    echo "example: ./deploy-ctl.sh apply cf --diff-changes --yes"
    exit 1
    ;;
  esac
  ;;

d | delete)
  shift
  case "${1}" in
  cm | cert-manager)
    shift
    kapp delete -a cert-manager "$@"
    ;;
  cf | cf-for-k8s)
    shift
    kapp delete -a cf "$@"
    ;;
  ed | external-dns)
    shift
    kapp delete -a external-dns "$@"
    ;;
  h | harbor)
    shift
    kapp delete -a harbor "$@"
    ;;
  qs | quarks-secret)
    shift
    kapp delete -a quarks-secret "$@"
    ;;
  sc | secretgen-controller)
    shift
    kapp delete -a secretgen-controller "$@"
    ;;
  all)
    shift
    kapp delete -a cf "$@"
    kapp delete -a harbor "$@"
    kapp delete -a external-dns "$@"
    kapp delete -a cert-manager "$@"
    kapp delete -a quarks-secret "$@"
    kapp delete -a secretgen-controller "$@"
    ;;
  *)
    echo "usage: ./deploy.sh delete {kapp-env} [optional-args...]"
    echo "usage: ./deploy.sh delete all [optional-args...]"
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
  # push apps already built via docker
  cf push -f ./cluster/config-optional/cf-for-k8s/cf-manifests/hash-browns-docker-no-routes.yml --strategy=rolling
  cf push -f ./cluster/config-optional/cf-for-k8s/cf-manifests/hash-browns-docker-routes.yml --strategy=rolling
  cf push -f ./cluster/config-optional/cf-for-k8s/cf-manifests/todo-ui-docker-routes.yml --strategy=rolling
  ;;
pip-source | cf-for-k8s-post-install-push-source-code-apps)
  # push an app from source code
  cf push test-node-app -p ./cluster/build/cf-for-k8s/_vendir/upstream/cf-for-k8s/tests/smoke/assets/test-node-app
  curl http://test-node-app.apps.cf.gershman.io/env
  ;;

cf-for-k8s-kpack-ecr-debug)
  exit 1
  # aws ecr get-login-password --region us-east-2
  kubectl -n cf-workloads-staging describe images
  kubectl -n cf-workloads-staging describe CustomBuilder
  kubectl -n cf-workloads-staging get images
  logs -namespace cf-workloads-staging -image XXX
  ;;

*)
  exit 1
  ;;
esac
