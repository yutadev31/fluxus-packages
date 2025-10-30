#!/bin/bash
set -euo pipefail

PKGS_DIR="$(pwd)/pkgs"
PKG_SCRIPT="make.sh"
SOURCES_DIR="$(pwd)/.sources"
DIST_DIR="$(pwd)/.dist"

PGP_KEYSERVER="keyservers.ubuntu.com"

log() {
  local level="$1"
  shift

  local RESET="\033[0m"
  local RED="\033[31m"
  local GREEN="\033[32m"
  local YELLOW="\033[33m"

  case "$level" in
  ok) color="$GREEN" ;;
  warn) color="$YELLOW" ;;
  err) color="$RED" ;;
  *) color="$RESET" ;;
  esac

  echo -e "${color}${level^^}:${RESET} $*"

  [[ "$level" == "err" ]] && return 1 || true
}

cleanup() {
  log ok "Cleaning up $pkg_name..."

  local pkg_name="$1"
  rm -rf /tmp/work-$pkg_name /tmp/pkg-$pkg_name
}

download_sources() {
  log ok "Downloading sources for $pkg_name..."

  local pkg_name="$1"
  local -n _sources="$2"

  for source_url in "${_sources[@]}"; do
    log ok "Downloading $source_url..."

    source_url="${source_url/https:\/\/ftp.gnu.org\/gnu/https:\/\/ftp.riken.jp\/GNU}"

    filename="$(basename "$source_url")"
    filepath="$SOURCES_DIR/$filename"

    if [[ $source_url == http* ]]; then
      if [[ -f "$filepath" ]]; then
        log ok "File already exists: $filepath"
      else
        wget "$source_url" -P "$SOURCES_DIR"
        log ok "Downloaded $source_url"
      fi
    fi
  done
}

checksums() {
  log ok "Checking checksums for $pkg_name..."

  local pkg_name="$1"
  local -n _sources="$2"

  for algo in md5 sha1 sha256 sha512; do
    local -n _sums="${algo}sums"

    if [[ -z "${_sums+x}" ]]; then
      continue
    fi

    log ok "Checking ${algo}sums..."

    if [[ ${#_sources[@]} -ne ${#_sums[@]} ]]; then
      log err "Number of sources and ${algo}sums do not match."
    fi

    for i in "${!_sources[@]}"; do
      local src="${_sources[$i]}"
      local expected="${_sums[$i]}"

      [[ $expected == "SKIP" ]] && continue

      local file="$sources_dir/$(basename "$src")"
      [[ ! -f "$file" ]] && log err "Missing file: $file"

      local actual="$($sumcmd "$file" | awk '{print $1}')"
      if [[ "$actual" == "$expected" ]]; then
        log ok "$(basename "$file") (${algo}sum match)"
      else
        log err "$(basename "$file") (${algo}sum mismatch)
  Expected: $expected
  Actual:   $actual"
      fi
    done
  done
}

verify_signatures() {
  local pkg_name="$1"
  local -n _sources="$2"
  local -n _keys="$3"

  for key in "${_keys[@]}"; do
    local norm="${key#0x}"
    if ! gpg --list-keys "$norm" >/dev/null 2>&1; then
      log warn "Key $norm not found; fetching..."
      gpg --keyserver "$PGP_KEYSERVER" --recv-keys "$norm" ||
        log warn "Failed to fetch key $norm"
    fi
  done

  for src in "${_sources[@]}"; do
    local base="$(basename "$src")"
    local file="$SOURCES_DIR/$base"

    if [[ $file == *.sign || $file == *.sig || $file == *.asc ]]; then
      continue
    fi

    local base_no_ext="${base%.*}"
    local base_no_tar_ext="${base_no_ext%.*}"
    local sigs=(
      "$SOURCES_DIR/$base_no_ext.sign"
      "$SOURCES_DIR/$base_no_ext.sig"
      "$SOURCES_DIR/$base_no_ext.asc"
      "$SOURCES_DIR/$base.sig"
      "$SOURCES_DIR/$base.asc"
      "$SOURCES_DIR/$base_no_tar_ext.sig"
    )

    local sig=""
    for s in "${sigs[@]}"; do
      if [[ -f "$s" ]]; then
        sig="$s"
        break
      fi
    done

    [[ -z "$sig" ]] && continue

    local verify_target="$file"
    local tmpfile=""

    if [[ "$sig" == *.tar.sign && "$file" == *.tar.xz ]]; then
      tmpfile=$(mktemp)
      xz -dc "$file" >"$tmpfile"
      verify_target="$tmpfile"
    fi

    local output
    if output=$(gpg --status-fd=1 --verify "$sig" "$verify_target" 2>&1); then
      local signers=()
      while read -r key; do
        signers+=("$key")
      done < <(awk '/^\[GNUPG:\] VALIDSIG /{print $3}' <<<"$output")

      local valid_signer_found=false

      for signer in "${signers[@]}"; do
        signer="${signer#0x}"
        if [[ " ${_keys[*]} " =~ $signer ]]; then
          log ok "$base valid signature by key $signer"
          valid_signer_found=true
        else
          log warn "$base signed by unknown key $signer"
        fi
      done

      if ! $valid_signer_found; then
        log err "$base signature valid but no trusted signer found"
      fi
    else
      log err "Signature check failed: $(basename "$sig")"
    fi

    [[ -n "$tmpfile" && -f "$tmpfile" ]] && rm -f "$tmpfile"
  done
}

copy_sources() {
  local pkg_name="$1"
  local -n _sources="$2"
  local work_dir="/tmp/work-$pkg_name"

  log ok "Copying sources to $work_dir"

  mkdir -p "$work_dir"

  for src_url in "${_sources[@]}"; do
    local filename="$(basename "$src_url")"
    local src="$SOURCES_DIR/$filename"
    local dest="$work_dir/$filename"

    [[ ! -f "$src" ]] && log err "Missing source file: $src"

    if [[ "$src" =~ \.tar\.(gz|xz|bz2|zst)$ || "$src" == *.tgz ]]; then
      tar -xf "$src" -C "$work_dir" --strip-components=1
      log ok "Extracted: $filename"
    else
      log ok "Copying $filename"
      cp "$src" "$dest"
    fi
  done
}

run_function() {
  local pkg_name="$1"
  local function_name="$2"
  local fakeroot="$3"

  local work_dir="/tmp/work-$pkg_name"
  local pkg_dir="/tmp/pkg-$pkg_name"

  mkdir -p "$pkg_dir"

  if [[ -n "${function_name+x}" ]]; then
    if [[ "${fakeroot}" == "true" ]]; then
      log ok "Running fakeroot function: $function_name"
      fakeroot bash -euo pipefail -c "touch .env.sh && source .env.sh; source $PKGS_DIR/$pkg_name/$PKG_SCRIPT; export pkgdir=\"$pkg_dir\"; cd \"$work_dir\"; if declare -f $function_name &>/dev/null; then $function_name; fi"
    else
      log ok "Running function: $function_name"
      bash -euo pipefail -c "touch .env.sh && source .env.sh; source $PKGS_DIR/$pkg_name/$PKG_SCRIPT; export pkgdir=\"$pkg_dir\"; cd \"$work_dir\"; if declare -f $function_name &>/dev/null; then $function_name; fi"
    fi
  else
    log err "No function specified"
  fi
}

check_dir_structure() {
  local pkg_name="$1"
  local pkg_dir="/tmp/pkg-$pkg_name"
  local bad_dirs=("bin" "sbin" "lib" "lib64" "usr/sbin" "tmp" "sys" "proc" "dev" "run")

  for bad in "${bad_dirs[@]}"; do
    if [[ -d "$pkg_dir/$bad" ]]; then
      log err "Invalid directory found in package: $bad"
    fi
  done
}

create_archive() {
  local pkg_name="$1"
  local pkg_dir="/tmp/pkg-$pkg_name"

  fakeroot tar -czf "$DIST_DIR/$pkg_name.tar.zst" -C "$pkg_dir" .
  log ok "Created archive: $pkg_name.tar.zst"
}

main() {
  pkg_name="$1"

  source "$PKGS_DIR/$pkg_name/$PKG_SCRIPT"

  cleanup "$pkg_name"

  if [[ -f "$DIST_DIR/$pkg_name.tar.zst" ]]; then
    log ok "Archive already exists"
    return
  fi

  download_sources "$pkg_name" "sources"
  checksums "$pkg_name" "sources"
  verify_signatures "$pkg_name" "sources" "validpgpkeys"
  copy_sources "$pkg_name" "sources"

  run_function "$pkg_name" "prepare" "false"
  run_function "$pkg_name" "build" "false"
  run_function "$pkg_name" "test" "false"
  run_function "$pkg_name" "package" "false"

  check_dir_structure "$pkg_name"
  create_archive "$pkg_name"

  cleanup "$pkg_name"

  log ok "Package $pkg_name built successfully"
}

packages="$@"

if [[ -z "$packages" ]]; then
  packages=$(ls "$PKGS_DIR")
fi

for pkg_name in $packages; do
  main "$pkg_name"
done

log ok "All packages built successfully"
