name="libidn2"
version="2.3.8"
release="1"
sources=(
  https://ftp.gnu.org/gnu/libidn/libidn2-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'A3CC9C870B9D310ABAD4CF2F51722B08FE4745A2' # Simon Josefsson <simon@josefsson.org>
)

build() {
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --disable-static
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
