name="acl"
version="2.3.2"
release="1"
sources=(
  https://download.savannah.gnu.org/releases/acl/acl-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'B902B5271325F892AC251AD441633B9FE837F581' # Mike Frysinger <vapier@gentoo.org>
)
dependencies=(
  libc
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
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
}
