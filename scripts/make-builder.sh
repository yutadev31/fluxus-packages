#!/bin/bash
set -uo pipefail

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

mkdir -p .tmp && sudo mkdir -p .tmp/builder

for package in "${packages[@]}"; do
  sudo ~/.cargo/bin/fpm install ".dist/$package.tar.zst" --dest .tmp/builder
done
