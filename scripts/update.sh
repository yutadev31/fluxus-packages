#!/bin/bash
set -euo pipefail

PKGS_DIR="$(pwd)/pkgs"
PKG_SCRIPT="make.sh"

pkg_name="$1"

source "$PKGS_DIR/$pkg_name/$PKG_SCRIPT"

new_version="$(fetch_latest)"

if [[ "$new_version" != "$version" ]]; then
  echo "New version available: $new_version"
fi
