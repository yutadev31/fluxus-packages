name="openssl"
version="3.6.0"
release="1"
sources=(
  https://github.com/openssl/openssl/releases/download/openssl-$version/openssl-$version.tar.gz{,.asc}
)
sha256sums=(
  'b6a5f44b7eb69e3fa35dbf15524405b44837a481d43d81daddde3ff21fcbb8e9'
  'SKIP'
)
validpgpkeys=(
  'BA5473A2B0587B07FB27CF2D216094DFD0CB81EF' # OpenSSL <openssl@openssl.org>
)
dependencies=(
  libc
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --openssldir=/etc/ssl
    --libdir=lib
    shared
    zlib-dynamic
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./config "${configure_options[@]}"

  make
}

test() {
  HARNESS_JOBS=$(nproc) make test
}

package() {
  sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
  make DESTDIR="$pkgdir" MANSUFFIX=ssl install

  cp -vr doc/* $pkgdir/usr/share/doc/openssl
}
