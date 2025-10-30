name="kbd"
version="2.9.0"
release="1"
sources=(
  https://www.kernel.org/pub/linux/utils/kbd/kbd-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/utils/kbd/sha256sums.asc
sha256sums=(
  'fb3197f17a99eb44d22a3a1a71f755f9622dd963e66acfdea1a45120951b02ed'
  'SKIP'
)
validpgpkeys=(
  '7F2A3D07298149A0793C9A4EA45ABA544CFFD434' # Alexey Gladkov <legion@kernel.org>
)

prepare() {
  sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
  sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
}

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-vlock
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
  install -vdm755 $pkgdir/usr/share/doc/kbd
  cp -R -v docs/doc -T $pkgdir/usr/share/doc/kbd
}
