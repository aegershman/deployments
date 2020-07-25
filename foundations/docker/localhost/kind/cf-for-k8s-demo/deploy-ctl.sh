#!/usr/bin/env bash

set -euo pipefail

case "$1" in
cf-for-k8s-full-install)
  ./deploy-ctl.sh cf-for-k8s-clean-values
  ./deploy-ctl.sh cf-for-k8s-build
  ./deploy-ctl.sh cf-for-k8s-apply
  ;;

cf-for-k8s-clean-values)
  cd ./deployments/cf-for-k8s/build
  ./build.sh clean-generated-cf-values
  ;;

cf-for-k8s-build)
  cd ./deployments/cf-for-k8s/build
  ./build.sh build
  ;;

cf-for-k8s-apply)
  kapp deploy -a cf -f ./deployments/cf-for-k8s/_rendered/cf/cf-for-k8s-rendered.yml --yes
  ;;

cf-for-k8s-post-install)
  cf api --skip-ssl-validation https://api.vcap.me
  cf auth admin $(yq r ./deployments/cf-for-k8s/_rendered/cf/cf-values-generated.yml 'cf_admin_password')
  cf target
  cf enable-feature-flag diego_docker
  cf create-org test-org
  cf create-space -o test-org test-space
  cf target -o test-org -s test-space
  ;;

cf-for-k8s-post-install-push)
  # push an app already built via docker
  cf push -f ./deployments/cf-for-k8s/config/user/cf-manifests/hash-browns-docker-no-routes.yml --strategy=rolling
  cf push -f ./deployments/cf-for-k8s/config/user/cf-manifests/hash-browns-docker-routes.yml --strategy=rolling
  cf push -f ./deployments/cf-for-k8s/config/user/cf-manifests/todo-ui-docker-routes.yml --strategy=rolling
  # push an app from source code
  cf push test-node-app -p ./deployments/cf-for-k8s/build/_vendir/github.com/cloudfoundry/cf-for-k8s/tests/smoke/assets/test-node-app
  curl http://test-node-app.vcap.me/env
  ;;

cf-for-k8s-post-install-minibroker)
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

cf-for-k8s-post-install-kpack-debug)
  kubectl -n cf-workloads-staging delete custombuilders cf-default-builder
  kubectl -n cf-workloads-staging get custombuilders -o yaml
  ;;

cf-for-k8s-post-install-harbor-debug)
  # for dockerhub, the registry auth target is "https://index.docker.io/v1/".
  # notice "library" is the project and "kuard-amd64" is the repository;
  # the repository was created automatically by virtue of the push.
  kubectl -n cf-workloads-staging get images
  logs -namespace cf-workloads-staging -image IMAGEHERE
  kubectl -n harbor port-forward svc/harbor 8080:80
  kubectl -n cf-workloads-staging describe pods
  curl -u admin:admin localhost:8080/api/v2.0/systeminfo
  curl localhost:8080/api/v2.0/systeminfo
  curl localhost:8080/api/v2.0/users/current
  curl -u admin:admin localhost:8080/api/v2.0/users/current
  curl -u admin:admin localhost:8080/api/v2.0/projects
  curl -u admin:admin localhost:8080/api/v2.0/projects/library/repositories
  kubectl -n harbor port-forward svc/harbor 8080:80
  #
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=core --tail 250
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=database --tail 250
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=jobservice --tail 250
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=nginx
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=portal --tail 250
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=redis --tail 250
  kubectl -n harbor logs -f -lapp=harbor -lcomponent=registry -c registry
  #
  docker login --username admin --password Harbor12345 localhost:4107
  docker pull gcr.io/kuar-demo/kuard-amd64:blue
  docker tag gcr.io/kuar-demo/kuard-amd64:blue localhost:4107/library/kuard-amd64:blue
  docker images
  docker push localhost:4107/library/kuard-amd64:blue
  ;;

cf-for-k8s-post-install-istio-debug)
  # https://istio.io/latest/docs/ops/common-problems/injection/
  kubectl get crds | grep istio
  kubectl get mutatingwebhookconfiguration istio-sidecar-injector -o yaml | grep "namespaceSelector:" -A5
  kubectl get namespace -L istio-injection
  #
  kubectl get destinationrules.networking.istio.io --all-namespaces
  kubectl get destinationrules.networking.istio.io --all-namespaces -o yaml | grep "host:"
  kubectl get gateways.networking.istio.io --all-namespaces
  kubectl get instances.config.istio.io --all-namespaces
  kubectl get meshpolicies.authentication.istio.io --all-namespaces
  kubectl get networkpolicy.networking.k8s.io --all-namespaces
  kubectl get policies.authentication.istio.io --all-namespaces
  kubectl get rules.config.istio.io --all-namespaces
  kubectl get sidecars.networking.istio.io --all-namespaces
  kubectl get virtualservices.networking.istio.io --all-namespaces
  #
  kubectl -n prometheus-operator exec -it prometheus-prometheus-operator-prometheus-0 -- /bin/sh
  #
  hash-browns.apps.vcap.me
  wget http://10.244.0.59:15090/stats/prometheus
  kubectl -n cf-workloads get svc s-8cfa43bb-2c8b-4877-bd28-b0b931a5491c -o wide
  10.99.18.73
  nslookup s-8cfa43bb-2c8b-4877-bd28-b0b931a5491c.cf-workloads.svc.cluster.local
  wget http://10.99.18.73:8080/metrics
  wget http://s-8cfa43bb-2c8b-4877-bd28-b0b931a5491c.cf-workloads.svc.cluster.local:8080/metrics
  wget http://10.99.18.73:8080/metrics
  #
  hash-browns.vcap.me
  wget http://s-3cd1c45a-0415-4b86-ac39-572d8d8db30a.cf-workloads.svc.cluster.local:8080/metrics
  kubectl -n cf-workloads get svc s-3cd1c45a-0415-4b86-ac39-572d8d8db30a -o wide
  10.111.83.238
  nslookup s-3cd1c45a-0415-4b86-ac39-572d8d8db30a.cf-workloads.svc.cluster.local
  wget http://10.111.83.238:8080/metrics
  #
  kubectl -n cf-workloads get endpoints -o yaml
  kubectl -n cf-workloads annotate endpoints ENDPOINT prometheus.io/scrape='true' prometheus.io/port='8080' prometheus.io/path='/metrics' --overwrite=true
  kubectl -n cf-workloads annotate endpoints s-3cd1c45a-0415-4b86-ac39-572d8d8db30a prometheus.io/scrape='true' prometheus.io/port='8080' prometheus.io/path='/metrics' --overwrite=true
  kubectl -n cf-workloads annotate svc s-3cd1c45a-0415-4b86-ac39-572d8d8db30a prometheus.io/scrape='true' prometheus.io/port='8080' prometheus.io/path='/metrics' --overwrite=true
  # https://istio.io/latest/docs/reference/commands/istioctl/
  istioctl analyze --all-namespaces
  istioctl dashboard envoy PODNAME.NAMESPACE
  istioctl x describe pod -n cf-workloads PODNAME
  ;;

*)
  exit 1
  ;;
esac
