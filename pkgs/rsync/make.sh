name="rsync"
version="3.4.1"
release="1"
sources=(
  https://www.samba.org/ftp/rsync/src/rsync-$version.tar.gz{,.asc}
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-xxhash
    --without-included-zlib
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
