name="patch"
version="2.8"
release="1"
sources=(
  https://ftp.gnu.org/gnu/patch/patch-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '259B3792B3D6D319212CC4DCD5BF9FEB0313653A' # Andreas Gruenbacher <agruenba@redhat.com>
)
dependencies=(
  attr
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

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
}
