name="psmisc"
version="23.7"
release="1"
sources=(
  https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-$version.tar.xz{,.asc}
)
validpgpkeys=(
  '5D3DF0F538B327C0AA7A77A2022166C0FF3C84E3' # Craig Small <csmall@dropbear.xyz>
)
dependencies=(
  ncurses
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

package() {
  make DESTDIR="$pkgdir" install
}
