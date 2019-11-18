#!/usr/bin/env bash

DIR_PREFIX="~/projects/deployments/bosh-lite"

bosh create-env ${DIR_PREFIX}/bosh-deployment/bosh.yml \
  --state ./state.json \
  -o ${DIR_PREFIX}/bosh-deployment/virtualbox/cpi.yml \
  -o ${DIR_PREFIX}/bosh-deployment/virtualbox/outbound-network.yml \
  -o ${DIR_PREFIX}/bosh-deployment/bosh-lite.yml \
  -o ${DIR_PREFIX}/bosh-deployment/bosh-lite-runc.yml \
  -o ${DIR_PREFIX}/bosh-deployment/uaa.yml \
  -o ${DIR_PREFIX}/bosh-deployment/credhub.yml \
  -o ${DIR_PREFIX}/bosh-deployment/jumpbox-user.yml \
  --vars-store ./creds.yml \
  -v director_name=bosh-lite \
  -v internal_ip=192.168.50.6 \
  -v internal_gw=192.168.50.1 \
  -v internal_cidr=192.168.50.0/24 \
  -v outbound_network_name=NatNetwork
