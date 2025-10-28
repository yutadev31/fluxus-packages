name="attr"
version="2.5.2"
release="1"
sources=(
  https://download.savannah.gnu.org/releases/attr/attr-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'B902B5271325F892AC251AD441633B9FE837F581' # Mike Frysinger <vapier@gentoo.org>
)
dependencies=(
  glibc
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --sysconfdir=/etc
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
