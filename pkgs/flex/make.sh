name="flex"
version="2.6.4"
release="1"
sources=(
  https://github.com/westes/flex/releases/download/v$version/flex-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'E4B29C8D64885307' # Will Estes <westes575@gmail.com>
)
dependencies=(
  sh
  libc
  m4
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
