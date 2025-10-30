#!/bin/bash
set -euo pipefail

packages=(
  binutils
  gcc
  linux
  glibc
  m4
  ncurses
  readline
  bash
  coreutils
  diffutils
  file
  findutils
  gawk
  grep
  gzip
  tar
  xz
)

for package in "${packages[@]}"; do
  ./scripts/make.sh "$package"
done
