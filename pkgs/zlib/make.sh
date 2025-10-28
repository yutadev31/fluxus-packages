name="zlib"
version="1.3.1"
release="1"
sources=(
  https://zlib.net/fossils/zlib-$version.tar.gz
)
dependencies=(
  zlib
)

build() {
  # TODO local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    # TODO CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
  rm -fv $pkgdir/usr/lib/libz.a
}
