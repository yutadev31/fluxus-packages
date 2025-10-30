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
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    --localstatedir=/var/lib/locate
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
