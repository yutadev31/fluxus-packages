name="libpipeline"
version="1.5.8"
release="1"
sources=(
  https://download.savannah.gnu.org/releases/libpipeline/libpipeline-$version.tar.gz{,.asc}
)
validpgpkeys=(
  'AC0A4FF12611B6FCCF01C111393587D97D86500B' # Colin Watson <cjwatson@chiark.greenend.org.uk>
)

build() {
  local LD="lld"
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
