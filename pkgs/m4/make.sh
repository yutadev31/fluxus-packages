name="m4"
version="1.4.20"
release="1"
sources=(
  https://ftp.gnu.org/gnu/m4/m4-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '71C2CC22B1C4602927D2F3AAA7A16B4A2527436A' # Eric Blake <eblake@redhat.com>
)
dependencies=(
  bash
  libc
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
