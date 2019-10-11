#!/usr/bin/env bash

set -e

case "$1" in
dec)
    sops --decrypt \
        --output-type dotenv \
        bosh/gershman-io/.envrc.enc >bosh/gershman-io/.envrc
    ;;

enc)
    sops --encrypt \
        --input-type dotenv \
        bosh/gershman-io/.envrc >bosh/gershman-io/.envrc.enc
    ;;
esac
