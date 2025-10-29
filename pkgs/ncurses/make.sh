name="ncurses"
version="6.5-20251018"
release="1"
sources=(
  https://invisible-mirror.net/archives/ncurses/current/ncurses-$version.tgz{,.asc}
)
validpgpkeys=(
  '19882D92DDA4C400C22C0D56CC2AF4472167BE03' # Thomas E. Dickey (use for email) <dickey@his.com>
)
dependencies=(
  gcc
  libc
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --mandir=/usr/share/man
    --with-shared
    --without-debug
    --without-normal
    --with-cxx-shared
    --enable-pc-files
    --with-pkg-config-libdir=/usr/lib/pkgconfig
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  for lib in ncurses form panel menu; do
    ln -vsf lib${lib}w.so $pkgdir/usr/lib/lib${lib}.so
    ln -vsf ${lib}w.pc $pkgdir/usr/lib/pkgconfig/${lib}.pc
  done

  ln -vsf libncursesw.so $pkgdir/usr/lib/libcurses.so

  install -vdm755 $pkgdir/usr/share/doc
  cp -v -R doc -T $pkgdir/usr/share/doc/ncurses
  # TODO cpをinstallに変える
}
