name="xz"
version="5.8.1"
release="1"
sources=(
  https://github.com/tukaani-project/xz/releases/download/v$version/xz-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '3690C240CE51B4670D30AD1C38EE757D69184620' # Lasse Collin <lasse.collin@tukaani.org>
)
dependencies=(
  sh
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --disable-static
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
