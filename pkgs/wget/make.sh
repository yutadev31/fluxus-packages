name="wget"
version="1.25.0"
release="1"
sources=(
  https://ftp.gnu.org/gnu/wget/wget-$version.tar.gz{,.sig}
)
validpgpkeys=(
  '6B98F637D879C5236E277C5C64FF90AAE8C70AF9' # Darshit Shah <gpg@darnir.net>
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
    --sysconfdir=/etc
    --with-ssl=openssl
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
