#!/usr/bin/env bash

set -euo pipefail

case "$1" in
eksctl-create) eksctl create cluster --config-file=eks-cluster.yaml ;;
eksctl-write-kubeconfig) eksctl utils write-kubeconfig --region=us-east-2 --cluster=aegershman-example-0 --auto-kubeconfig ;;
eksctl-delete) eksctl delete cluster -f ./eks-cluster.yaml ;;

cf-for-k8s-diff-cf-generate-values) diff ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/hack/generate-values.sh ./deployments/cf-for-k8s/build/generate-values.sh ;;
cf-for-k8s-clean-values) ./deployments/cf-for-k8s/build/build.sh clean-generated-cf-values ;;
cf-for-k8s-generate-values) ./deployments/cf-for-k8s/build/build.sh generate-values ;;

helmfile-template)
  # TODO having some issues with harbor continuously regenerating it's secrets every time 'template' is ran, which is annoying
  # but also definitely needs to be investigated to make sure it doesn't break other things
  helmfile --selector=name!=harbor template --skip-deps --output-dir="./deployments" --output-dir-template="{{ .OutputDir }}/{{ .Release.Name }}/_rendered/helmfile"
  ;;

render)
  ytt --ignore-unknown-comments \
    -f ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/config \
    -f ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-resource-requirements.yml \
    -f ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/add-metrics-server-components.yml \
    -f ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/patch-metrics-server.yml \
    -f ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/use-external-dns-for-wildcard.yml \
    -f ./deployments/cf-for-k8s/_rendered/cf-values-generated.yml \
    -f ./deployments/cf-for-k8s/build/config/opsfiles/cf-registry-values-harbor.yml \
    -f ./deployments/external-dns/_rendered \
    -f ./deployments/external-dns/build/config/opsfiles/external-dns-ns.yml \
    -f ./deployments/harbor/build/config/opsfiles/harbor-namespace.yml \
    -f ./deployments/harbor/build/config/opsfiles/harbor-virtual-service.yml \
    -f ./deployments/prometheus-operator/build/config/opsfiles/grafana-virtual-service.yml \
    -f ./deployments/prometheus-operator/build/config/opsfiles/prometheus-operator-namespace.yml \
    >./deployments/_rendered/_rendered.yml
  ;;

cf-for-k8s-apply) kapp deploy -a cf -f ./deployments/_rendered/_rendered.yml --yes ;;
cf-for-k8s-delete) kapp delete -a cf --yes ;;

cf-for-k8s-post-install)
  cf api --skip-ssl-validation https://api.cf.gershman.io
  cf auth admin $(yq r ./deployments/cf-for-k8s/_rendered/cf-values-generated.yml 'cf_admin_password')
  cf target
  cf enable-feature-flag diego_docker
  cf create-org test-org
  cf create-space -o test-org test-space
  cf target -o test-org -s test-space
  ;;

cf-for-k8s-post-install-push)
  exit 1
  # push an app already built via docker
  cf push -f ./deployments/cf-for-k8s/build/config/cf-manifests/hash-browns-docker-no-routes.yml --strategy=rolling
  cf push -f ./deployments/cf-for-k8s/build/config/cf-manifests/hash-browns-docker-routes.yml --strategy=rolling
  cf push -f ./deployments/cf-for-k8s/build/config/cf-manifests/todo-ui-docker-routes.yml --strategy=rolling
  # push an app from source code
  cf push test-node-app -p ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/tests/smoke/assets/test-node-app
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
