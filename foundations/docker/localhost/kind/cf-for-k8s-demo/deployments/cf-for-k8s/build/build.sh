#!/usr/bin/env bash

case "$1" in
generate-values)
  # vcap.me == nip.io == xip.io, allowing for localhost dns
  ./generate-values.sh --silence-hack-warning --cf-domain vcap.me >../_rendered/cf/cf-values-generated.yml
  ;;
esac
