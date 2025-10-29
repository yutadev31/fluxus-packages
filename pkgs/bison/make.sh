name="bison"
version="3.8.2"
release="1"
sources=(
  https://ftp.gnu.org/gnu/bison/bison-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E' # Akim Demaille <akim.demaille@gmail.com>
)
dependencies=(
  sh
  gettext
  libc
  m4
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
