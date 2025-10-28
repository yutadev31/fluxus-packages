name="zstd"
version="1.5.7"
release="1"
sources=(
  https://github.com/facebook/zstd/releases/download/v$version/zstd-$version.tar.gz{,.sig}
)
sha256sums=(
  'eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3'
  'SKIP'
)
validpgpkeys=(
  '4EF4AC63455FC9F4545D9B7DEF8FE99528B52FFD' # Zstandard Release Signing Key <signing@zstd.net>
)
dependencies=(
  gcc
  glibc
  lz4
  zlib
)

build() {
  # TODO local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"

  make prefix=/usr # TODO CFLAGS="$CFLAGS"
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" prefix=/usr install
  rm -v $pkgdir/usr/lib/libzstd.a
}
