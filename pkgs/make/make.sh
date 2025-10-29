name="make"
version="4.4.1"
release="1"
sources=(
  https://ftp.gnu.org/gnu/make/make-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'B2508A90102F8AE3B12A0090DEACCAAEDB78137A' # Paul D. Smith <paul@mad-scientist.net>
)
dependencies=(
  libc
  guile
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
