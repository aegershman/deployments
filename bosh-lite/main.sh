#!/usr/bin/env bash

set -e

case "$1" in
c | create)
  DEPLOY_DIR="vendor/bosh-deployment"
  STATE_DIR="vendor/state"

  bosh create-env ${DEPLOY_DIR}/bosh.yml \
    --state ${STATE_DIR}/state.json \
    --vars-store ${STATE_DIR}/creds.yml \
    -o ${DEPLOY_DIR}/bosh-lite-runc.yml \
    -o ${DEPLOY_DIR}/bosh-lite.yml \
    -o ${DEPLOY_DIR}/jumpbox-user.yml \
    -o ${DEPLOY_DIR}/virtualbox/cpi.yml \
    -o ${DEPLOY_DIR}/virtualbox/outbound-network.yml \
    -v director_name="Bosh Lite Director" \
    -v internal_cidr=192.168.50.0/24 \
    -v internal_gw=192.168.50.1 \
    -v internal_ip=192.168.50.6 \
    -v outbound_network_name=NatNetwork
  ;;

*)
  exit 1
  ;;
esac
