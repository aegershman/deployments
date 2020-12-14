#!/usr/bin/env bash

set -e

case "$1" in
build)
  for b in ./cluster/build/*; do
    pushd "${b}"
    echo "in ${b}..."
    ./build.sh
    popd
  done
  ;;

a | apply | deploy)
  shift
  case "${1}" in
  cfo | cf-operator)
    shift
    kapp deploy -a cf-operator -f <(
      ytt \
        -f ./cluster/config/cf-operator/
    ) "$@"
    ;;
  in | ingress-nginx)
    shift
    kapp deploy -a ingress-nginx -f <(
      ytt \
        -f ./cluster/config/ingress-nginx/
    ) "$@"
    ;;
  kc | kubecf)
    shift
    kapp deploy -a kubecf -f <(
      ytt \
        -f ./cluster/config/kubecf/
    ) "$@"
    ;;
  all)
    shift
    ./deploy-ctl.sh apply ingress-nginx "$@"
    ./deploy-ctl.sh apply cf-operator "$@"
    ./deploy-ctl.sh apply kubecf "$@"
    ;;
  *)
    echo "usage: ./deploy.sh apply all [optional-args...]"
    echo "usage: ./deploy.sh apply {kapp-env} [optional-args...]"
    echo "example: ./deploy-ctl.sh apply kubecf --yes"
    echo "example: ./deploy-ctl.sh apply kubecf --diff-changes --yes"
    exit 1
    ;;
  esac
  ;;

d | delete)
  shift
  case "${1}" in
  cfo | cf-operator)
    shift
    kapp delete -a cf-operator "$@"
    ;;
  in | ingress-nginx)
    shift
    kapp delete -a ingress-nginx "$@"
    ;;
  kc | kubecf)
    shift
    kapp delete -a kubecf "$@"
    ;;
  all)
    shift
    ./deploy-ctl.sh delete -a ingress-nginx "$@"
    ./deploy-ctl.sh delete -a cf-operator "$@"
    ./deploy-ctl.sh delete -a kubecf "$@"
    ;;
  *)
    echo "usage: ./deploy.sh delete {kapp-env} [optional-args...]"
    echo "usage: ./deploy.sh delete all [optional-args...]"
    echo "example: ./deploy-ctl.sh delete kubecf --yes"
    exit 1
    ;;
  esac
  ;;

*)
  exit 1
  ;;
esac
