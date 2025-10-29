name="less"
version="685"
release="1"
sources=(
  https://www.greenwoodsoftware.com/less/less-$version{.tar.gz,.sig}
)
validpgpkeys=(
  'AE27252BD6846E7D6EAE1DD6F153A7C833235259' # Mark Nudelman <markn@greenwoodsoftware.com>
)
dependencies=(
  libc
  ncurses
  # TODO pcre2
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --sysconfdir=/etc
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
