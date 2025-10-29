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
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --mandir=/usr/share/man
    --enable-threads
    --enable-64bit
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  SRCDIR=$(pwd)
  cd unix

  ./configure "${configure_options[@]}"

  make
}

package() {
  cd unix

  make DESTDIR="$pkgdir" install
  make DESTDIR="$pkgdir" install-private-headers
}
