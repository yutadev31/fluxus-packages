name="gawk"
version="5.3.2"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gawk/gawk-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'D1967C63788713177D861ED7DF597815937EC0D2' # Arnold Robbins <arnold@skeeve.com>
)
provides=(
  awk
)
dependencies=(
  sh
  libc
  mpfr
)

prepare() {
  sed -i 's/extras//' Makefile.in
}

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
