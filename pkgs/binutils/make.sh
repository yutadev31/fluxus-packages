name="binutils"
version="2.45"
release="1"
sources=(
  https://ftp.gnu.org/gnu/binutils/binutils-$version.tar.zst{,.sig}
)
validpgpkeys=(
  '3A24BC1E8FB409FA9F14371813FCEF89DD9E3C4F' # Nick Clifton (Chief Binutils Maintainer) <nickc@redhat.com>
)
dependencies=(
  libc
  jansson
  libelf
  zlib
  zstd
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --sysconfdir=/etc
    --enable-ld=default
    --enable-plugins
    --enable-shared
    --disable-werror
    --enable-64-bit-bfd
    --enable-new-dtags
    --with-system-zlib
    --enable-default-hash-style=gnu
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  mkdir -v build && cd build

  ../configure "${configure_options[@]}"

  make
}

test() {
  cd build

  make -k check
}

package() {
  cd build

  make DESTDIR="$pkgdir" install

  rm -rfv $pkgdir/usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a
}
