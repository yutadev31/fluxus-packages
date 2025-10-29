name="mpc"
version="1.3.1"
release="1"
sources=(
  https://ftp.gnu.org/gnu/mpc/mpc-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'AD17A21EF8AED8F1CC02DBD9F7D5C9BF765C61E3' # Andreas Enge <andreas@enge.fr>
)
dependencies=(
  libc
  libmpdclient
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
  make html
}

package() {
  make DESTDIR="$pkgdir" install
  make DESTDIR="$pkgdir" install-html
}
