name="lz4"
version="1.10.0"
release="1"
sources=(
  https://github.com/lz4/lz4/releases/download/v$version/lz4-$version.tar.gz
)
sha256sums=(
  '537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b'
)
dependencies=(
  libc
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"

  make BUILD_STATIC=no PREFIX=/usr CC="$CC" CFLAGS="$CFLAGS"
}

package() {
  make DESTDIR="$pkgdir" BUILD_STATIC=no PREFIX=/usr install
}
