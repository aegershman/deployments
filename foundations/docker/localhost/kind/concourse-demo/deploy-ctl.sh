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

concourse-debug)
  fly -t localhost login -c http://concourse.vcap.me -u test -p test -n main -k
  fly -t localhost sync
  fly -t localhost sp -p demo -c demo/pipeline.yml -l demo/params.yml -n
  fly -t localhost up -p demo
  fly -t localhost tj -j demo/make-a-change
  fly -t localhost tj -j demo/this-will-fail
  fly -t localhost tj -j demo/make-a-change --watch
  fly -t localhost tj -j demo/this-will-fail --watch
  fly -t localhost hijack -j demo/make-a-change
  fly -t localhost hijack -j demo/this-will-fail
  ;;

jaeger-debug)
  exit 1
  kubectl -n jaeger-operator get jaeger
  kubectl -n jaeger-operator delete jaeger.jaegertracing.io/jaeger-operator-jaeger
  kubectl -n jaeger-operator get pods -l app.kubernetes.io/instance=jaeger-operator-jaeger
  kubectl -n jaeger-operator logs -f -l app.kubernetes.io/instance=jaeger-operator-jaeger
  kubectl -n jaeger-operator get pods -l app.kubernetes.io/name=jaeger-operator
  kubectl -n jaeger-operator logs -f -l app.kubernetes.io/name=jaeger-operator
  ;;

*)
  echo "usage: ./deploy.sh build"
  exit 1
  ;;
esac
