#!/usr/bin/env bash

set -e

case "$1" in

s | set)
  fly -t localhost set-pipeline \
    -p bbl-gershman \
    -c ci/pipeline.yml \
    -l ci/params.yml \
    -l ci/.credentials.yml
  ;;

-h | --help | *)
  cat <<-EOF
usage:
  n/a
EOF

  exit 1
  ;;
esac
