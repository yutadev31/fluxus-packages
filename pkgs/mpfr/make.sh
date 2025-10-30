name="mpfr"
version="4.2.2"
release="1"
sources=(
  https://ftp.gnu.org/gnu/mpfr/mpfr-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'A534BE3F83E241D918280AEB5831D11A0D4DB02A' # Vincent Lefevre <vincent@vinc17.net>
)
dependencies=(
  libc
  gmp
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --enable-thread-safe
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
  make html
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
  make DESTDIR="$pkgdir" install-html
}
