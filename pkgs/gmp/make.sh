name="gmp"
version="6.3.0"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gmp/gmp-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '343C2FF0FBEE5EC2EDBEF399F3599FF828C67298'
)
dependencies=(
  gcc
  libc
)

prepare() {
  sed -i '/long long t1;/,+1s/()/(...)/' configure
}

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --enable-cxx
    --disable-static
    --host=none-linux-gnu
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
