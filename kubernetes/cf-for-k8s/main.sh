#!/usr/bin/env bash

echo "Don't use this, it's only here so I can test some stuff before moving it into the Taskfile"
echo "... It's also here so that I can get my autoformatter for format shell"
exit 1

case "$1" in
deploy)
  ytt \
    -f config/vendor/github.com/cloudfoundry/cf-for-k8s/config \
    -f /tmp/cf-values.yml \
    -f config/vendor/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-resource-requirements.yml \
    -f config/vendor/github.com/cloudfoundry/cf-for-k8s/config-optional/remove-ingressgateway-service.yml \
    >/tmp/cf-for-k8s-ytt.yml
  ;;

*)
  exit 1
  ;;
esac
