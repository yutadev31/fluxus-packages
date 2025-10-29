name="gzip"
version="1.14"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gzip/gzip-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '155D3FC500C834486D1EEA677FD9FCCB000BEEEE' # Jim Meyering <jim@meyering.net>
)
dependencies=(
  bash
  coreutils
  libc
  sed
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

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
}
