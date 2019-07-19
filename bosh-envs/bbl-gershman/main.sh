#!/usr/bin/env bash

set -e

case "$1" in
-h | --help | *)
  cat <<-EOF
usage:
  n/a
EOF

  exit 1
  ;;
esac
