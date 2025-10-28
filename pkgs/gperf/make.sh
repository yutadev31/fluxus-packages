name="gperf"
version="3.3"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gperf/gperf-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'E0FFBD975397F77A32AB76ECB6301D9E1BBEAC08' # Bruno Haible (Free Software Development) <bruno@clisp.org>
)
dependencies=(
  gcc
  glibc
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
