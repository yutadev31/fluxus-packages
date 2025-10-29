name="libunistring"
version="1.3"
release="1"
sources=(
  https://ftp.gnu.org/gnu/libunistring/libunistring-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '9001B85AF9E1B83DF1BDA942F5BE8B267C6A406D' # Bruno Haible (Open Source Development) <bruno@clisp.org>
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
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
