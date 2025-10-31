#!/bin/bash
set -u

packages="$(ls pkgs)"

for package in $packages; do
  ./scripts/make.sh $package
done
