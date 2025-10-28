name="procps-ng"
version="4.0.5"
release="1"
sources=(
  https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-$version.tar.xz{,.asc}
)
validpgpkeys=(
  '5D3DF0F538B327C0AA7A77A2022166C0FF3C84E3' # Craig Small <csmall@dropbear.xyz>
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --disable-kill
    --enable-watch8bit
    --with-systemd
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
