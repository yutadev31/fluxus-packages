name="tar"
version="1.35"
release="1"
sources=(
  https://ftp.gnu.org/gnu/tar/tar-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '325F650C4C2B6AD58807327A3602B07F55D0C732' # Sergey Poznyakoff (Gray) <gray@mirddin.farlep.net>
)
dependencies=(
  acl
  libc
  attr
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --sbindir=/usr/bin
    --libexecdir=/usr/lib/tar
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
