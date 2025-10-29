name="file"
version="5.46"
release="1"
sources=(
  https://astron.com/pub/file/file-$version.tar.gz{,.asc}
)
validpgpkeys=(
  'BE04995BA8F90ED0C0C176C471112AB16CB33B3A' # Christos Zoulas (personal key) <christos@zoulas.com>
)
dependencies=(
  bzip2
  libc
  libseccomp
  xz
  zlib
  zstd
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
}
