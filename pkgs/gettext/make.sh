name="gettext"
version="0.26"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gettext/gettext-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'E0FFBD975397F77A32AB76ECB6301D9E1BBEAC08' # Bruno Haible (Free Software Development) <bruno@clisp.org>
)
dependencies=(
  acl
  attr
  sh
  gcc
  # TODO gnulib-l10n
  # TODO libunistring
  # TODO libxml2
  ncurses
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
}

package() {
  make DESTDIR="$pkgdir" install
  chmod -v 0755 $pkgdir/usr/lib/preloadable_libintl.so
}
