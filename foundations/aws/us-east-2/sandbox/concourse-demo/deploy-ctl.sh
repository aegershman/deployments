#!/usr/bin/env bash

set -euo pipefail

case "$1" in
eksc | eksctl-create) eksctl create cluster --config-file=eks-cluster.yaml ;;
eksctl-write-kubeconfig) eksctl utils write-kubeconfig --region=us-east-2 --cluster=concourse-demo --auto-kubeconfig ;;
eksd | eksctl-delete) eksctl delete cluster -f ./eks-cluster.yaml ;;

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
  cweb | concourse-web)
    shift
    kapp deploy -a concourse-web -f <(
      ytt --ignore-unknown-comments \
        -f ./cluster/config/concourse-web
    ) "$@"
    ;;
  cwork | concourse-workers)
    shift
    kapp deploy -a external-dns -f <(
      ytt --ignore-unknown-comments \
        -f ./cluster/config/concourse-workers
    ) "$@"
    ;;
  ed | external-dns)
    shift
    kapp deploy -a external-dns -f <(
      ytt -f ./cluster/config/external-dns/
    ) "$@"
    ;;
  i | ingress-nginx)
    shift
    kapp deploy -a ingress-nginx -f <(
      ytt -f ./cluster/config/ingress-nginx/
    ) "$@"
    ;;

  all)
    shift
    ./deploy-ctl.sh apply concourse-web "$@"
    ./deploy-ctl.sh apply concourse-workers "$@"
    ./deploy-ctl.sh apply external-dns "$@"
    ./deploy-ctl.sh apply ingress-nginx "$@"
    ;;
  *)
    echo "usage: ./deploy.sh apply all [optional-args...]"
    echo "usage: ./deploy.sh apply {kapp-env} [optional-args...]"
    echo "example: ./deploy-ctl.sh apply concourse-web --yes"
    exit 1
    ;;
  esac
  ;;

d | delete)
  shift
  case "${1}" in
  cweb | concourse-web)
    shift
    kapp delete -a concourse-web "$@"
    ;;
  cwork | concourse-workers)
    shift
    kapp delete -a concourse-workers "$@"
    ;;
  ed | external-dns)
    shift
    kapp delete -a external-dns "$@"
    ;;
  i | ingress-nginx)
    shift
    kapp deploy -a ingress-nginx -f <(
      ytt -f ./cluster/config/ingress-nginx/
    ) "$@"
    ;;
  all)
    shift
    kapp delete -a concourse-web "$@"
    kapp delete -a concourse-workers "$@"
    kapp delete -a external-dns "$@"
    kapp delete -a ingress-nginx "$@"
    ;;
  *)
    echo "usage: ./deploy.sh delete {kapp-env} [optional-args...]"
    echo "usage: ./deploy.sh delete all [optional-args...]"
    echo "example: ./deploy-ctl.sh delete concourse-web --yes"
    exit 1
    ;;
  esac
  ;;

*)
  echo "usage: ./deploy.sh build"
  exit 1
  ;;
esac
