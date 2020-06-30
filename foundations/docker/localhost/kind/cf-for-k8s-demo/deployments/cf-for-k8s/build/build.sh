#!/usr/bin/env bash

case "$1" in
generate-values)
  # vcap.me == nip.io == xip.io, allowing for localhost dns
  ./generate-values.sh --silence-hack-warning --cf-domain vcap.me >../_rendered/cf/cf-values-generated.yml
  ;;

ytt)
  ytt \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-ingressgateway-service.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-resource-requirements.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/add-metrics-server-components.yml \
    -f _vendir/github.com/cloudfoundry/cf-for-k8s/config-optional/patch-metrics-server.yml \
    -f ../_rendered/cf/cf-values-generated.yml \
    -f ../config/user/opsfiles/cf-registry-values.yml \
    -f ../../harbor/user/opsfiles/harbor-namespace.yml \
    -f ../../harbor/user/opsfiles/harbor-virtual-service.yml \
    -f ../../jaeger-operator/user/opsfiles/jaeger-operator-namespace.yml \
    -f ../../jaeger-operator/user/opsfiles/jaeger-virtual-service.yml \
    -f ../../minibroker/user/opsfiles/minibroker-namespace.yml \
    -f ../../prometheus-operator/user/opsfiles/alertmanager-virtual-service.yml \
    -f ../../prometheus-operator/user/opsfiles/grafana-virtual-service.yml \
    -f ../../prometheus-operator/user/opsfiles/prometheus-network-policy.yml \
    -f ../../prometheus-operator/user/opsfiles/prometheus-operator-namespace.yml \
    -f ../../prometheus-operator/user/opsfiles/prometheus-virtual-service.yml \
    -f ../../service-catalog/user/opsfiles/catalog-namespace.yml \
    >../_rendered/cf/cf-for-k8s-rendered.yml
  ;;
esac
