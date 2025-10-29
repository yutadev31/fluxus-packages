name="bzip2"
version="1.0.8"
release="1"
sources=(
  https://www.sourceware.org/pub/bzip2/bzip2-$version.tar.gz{,.sig}
)
sha512sums=(
  '083f5e675d73f3233c7930ebe20425a533feedeaaa9d8cc86831312a6581cefbe6ed0d08d2fa89be81082f2a5abdabca8b3c080bf97218a1bd59dc118a30b9f3'
  '4a4a3fa0ec1c10a704b9870e8e629fd007cca55184423c6bfc3049a702fb41e4aeb73bfe9ca7442c27d32d278f1f34f27523a6be67d35b37896acdded12bf40d'
)
validpgpkeys=(
  '12768A96795990107A0D2FDFFC57E3CCACD99A78' # Mark Wielaard <mark@klomp.org>
)
dependencies=(
  sh
  libc
)

prepare() {
  sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
  sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

  make -f Makefile-libbz2_so
  make clean
}

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"

  make CC="$CC" CFLAGS="$CFLAGS"
}

package() {
  make PREFIX=$pkgdir/usr install

  cp -va libbz2.so.* $pkgdir/usr/lib
  ln -vs libbz2.so.$version $pkgdir/usr/lib/libbz2.so

  cp -v bzip2-shared $pkgdir/usr/bin/bzip2
  ln -vs bzip2 $pkgdir/usr/bin/bunzip2

  rm -vf $pkgdir/usr/lib/libbz2.a
}
