#!/usr/bin/env bash

set -e

case "$1" in
build)
  exit 1
  ;;

a | apply)
  exit 1
  ;;

*)
  exit 1
  ;;
esac
