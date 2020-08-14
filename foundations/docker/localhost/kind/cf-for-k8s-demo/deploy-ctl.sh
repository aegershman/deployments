#!/usr/bin/env bash

set -e

case "$1" in
build)
  shift
  case "${1}" in
  cf | cf-for-k8s)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh
    popd
    ;;
  cfd | cf-diff-generated-values)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh diff
    popd
    ;;
  cfr | cf-regenerate-values)
    pushd ./cluster/build/cf-for-k8s
    ./build.sh clean
    ./build.sh generate
    popd
    ;;
  h | harbor)
    pushd ./cluster/build/harbor
    ./build.sh
    popd
    ;;
  m | minibroker)
    pushd ./cluster/build/minibroker
    ./build.sh
    popd
    ;;
  sc | service-catalog)
    pushd ./cluster/build/service-catalog
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
    echo "usage: ./deploy-ctl.sh build {cfd, cf-diff-generated-values}"
    echo "example: ./deploy-ctl.sh build cfd"
    echo "usage: ./deploy-ctl.sh build {cfr, cf-regenerate-values}"
    echo "example: ./deploy.sh build cf-regenerate-values"
    exit 1
    ;;
  esac
  ;;

a | apply | deploy)
  shift
  case "${1}" in
  cf | cf-for-k8s)
    shift
    kapp deploy -a cf -f <(
      ytt \
        -f ./cluster/config/cf-for-k8s/ \
        -f ./cluster/config-optional/cf-for-k8s/system-certificate-cert-manager-staging.yml
    ) "$@"
    ;;
  h | harbor)
    shift
    kapp deploy -a harbor -f <(
      ytt \
        -f ./cluster/config/harbor/ \
        -f ./cluster/config-optional/harbor/harbor-virtual-service.yml
    ) "$@"
    ;;
  all)
    shift
    ./deploy-ctl.sh apply cert-manager "$@"
    ./deploy-ctl.sh apply cf-for-k8s "$@"
    ./deploy-ctl.sh apply harbor "$@"
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
  cf | cf-for-k8s)
    shift
    kapp delete -a cf "$@"
    ;;
  h | harbor)
    shift
    kapp delete -a harbor "$@"
    ;;
  all)
    shift
    kapp delete -a cf "$@"
    kapp delete -a harbor "$@"
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
  cf push test-node-app -p ./cluster/build/cf-for-k8s/_vendir/cf-for-k8s/tests/smoke/assets/test-node-app
  curl http://test-node-app.apps.cf.gershman.io/env
  ;;

pipm | cf-for-k8s-post-install-minibroker)
  cf create-service-broker minibroker user pass http://minibroker-minibroker.minibroker.svc
  cf enable-service-access mysql
  cf enable-service-access redis
  cf enable-service-access mongodb
  cf enable-service-access mariadb
  cf create-service mariadb 10-3-22 mariadb-svc
  cf service mariadb-svc
  cf create-service-key mariadb-svc mykey
  cf bind-service todo-ui mariadb-svc
  ;;

*)
  exit 1
  ;;
esac
