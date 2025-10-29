name="curl"
version="8.16.0"
release="1"
sources=(
  https://curl.se/download/curl-$version.tar.xz
)
dependencies=(
  libpsl
  make-ca
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --with-openssl
    --with-ca-path=/etc/ssl/certs
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
