name="man-db"
version="2.13.1"
release="1"
sources=(
  https://download.savannah.gnu.org/releases/man-db/man-db-$version.tar.xz{,.asc}
)
validpgpkeys=(
  'AC0A4FF12611B6FCCF01C111393587D97D86500B' # Colin Watson <cjwatson@chiark.greenend.org.uk>
)
dependencies=(
  libpipeline
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --sysconfdir=/etc
    --disable-setuid
    --enable-cache-owner=bin
    --with-browser=/usr/bin/lynx
    --with-vgrind=/usr/bin/vgrind
    --with-grap=/usr/bin/grap
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
