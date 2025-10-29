name="libelf"
version="0.193"
release="1"
sources=(
  https://sourceware.org/ftp/elfutils/$version/elfutils-$version.tar.bz2{,.sig}
)
sha512sums=(
  '557e328e3de0d2a69d09c15a9333f705f3233584e2c6a7d3ce855d06a12dc129e69168d6be64082803630397bd64e1660a8b5324d4f162d17922e10ddb367d76'
  '75f3935c4a519dc0b23e59e2e6f2bae7926c988aec484f2e1f0759cf7662eca1752f02c16b2f129fee0d7451e961322cf9a315c4ce23e91520f4779ed9fda713'
)
validpgpkeys=(
  '6C2B631563B8D330578D3CB474FD3FA2779E7073' # Aaron Merey <amerey@redhat.com>
)
dependencies=(
  bzip2
  curl
  libc
  xz
  zlib
  zstd
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-debuginfod
    --enable-libdebuginfod=dummy
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" -C libelf install
  install -vdm755 $pkgdir/usr/lib/pkgconfig
  install -vm644 config/libelf.pc $pkgdir/usr/lib/pkgconfig
  rm $pkgdir/usr/lib/libelf.a
}
