name="groff"
version="1.23.0"
release="1"
sources=(
  https://ftp.gnu.org/gnu/groff/groff-$version.tar.gz{,.sig}
)
validpgpkeys=(
  '2D0C08D2B0AD0D3D8626670272D23FBAC99D4E75' # Bertrand Garrigues <bertrand.garrigues@laposte.net>
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  PAGE=A4 ./configure "${configure_options[@]}"

  make
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
}
