name="findutils"
version="4.10.0"
release="1"
sources=(
  https://ftp.gnu.org/gnu/findutils/findutils-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'A5189DB69C1164D33002936646502EF796917195' # Bernhard Voelker <mail@bernhard-voelker.de>
)
dependencies=(
  libc
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    --localstatedir=/var/lib/locate
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
