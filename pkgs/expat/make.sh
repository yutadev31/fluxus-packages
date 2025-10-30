name="expat"
version="2.7.3"
release="1"
sources=(
  https://github.com/libexpat/libexpat/releases/download/R_${version//./_}/expat-$version.tar.xz{,.asc}
)
sha256sums=(
  '71df8f40706a7bb0a80a5367079ea75d91da4f8c65c58ec59bcdfbf7decdab9f'
  'be48d9b4ff898cd2f68cd810179330569ae57c482b3a4a50d1ca8d7900d67020'
)
validpgpkeys=(
  'CB8DE70A90CFBF6C3BF5CC5696262ACFFBD3AEC6' # Sebastian Pipping <sping@gentoo.org>
)
dependencies=(
  libc
)

build() {
  local CC="gcc"
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

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install

  install -vm644 doc/*.{html,css} $pkgdir/usr/share/doc/expat
}
