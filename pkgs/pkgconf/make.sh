name="pkgconf"
version="2.5.1"
release="1"
sources=(
  https://distfiles.ariadne.space/pkgconf/pkgconf-$version.tar.xz
)
dependencies=(
  glibc
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"
}

package() {
  make DESTDIR="$pkgdir" install

  ln -vs pkgconf $pkgdir/usr/bin/pkg-config
  ln -vs pkgconf.1 $pkgdir/usr/share/man/man1/pkg-config.1
}
