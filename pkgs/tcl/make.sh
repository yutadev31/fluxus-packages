name="tcl"
version="9.0.2"
release="1"
sources=(
  https://downloads.sourceforge.net/tcl/tcl$version-src.tar.gz
)
md5sums=(
  '5f5924db555be43ab3625dc16bf3f796'
)
dependencies=(
  zlib
)

build() {
  SRCDIR=$(pwd)
  cd unix

  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --mandir=/usr/share/man
    --enable-threads
    --enable-64bit
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
  make DESTDIR="$pkgdir" install-private-headers
}
