#!/usr/bin/env bash

set -e

case "$1" in
b | bootstrap)
  echo "Ensuring you are targeting the correct kubectl..."
  kubectl config use-context docker-for-desktop

  kubectl apply -f bootstrap/rbac-tiller.yml
  helm init --service-account tiller
  ;;

l | concourse-login)
  fly -t localhost login -c http://concourse.127.0.0.1.xip.io -k -u test -p test -n main
  fly -t localhost sync
  ;;

-h | --help | *)
  cat <<-EOF
usage:
  ./main.sh bootstrap
EOF

  exit 1
  ;;
esac
