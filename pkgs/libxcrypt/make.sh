name="libxcrypt"
version="4.4.38"
release="1"
sources=(
  https://github.com/besser82/libxcrypt/releases/download/v$version/libxcrypt-$version.tar.xz{,.asc}
)
sha256sums=(
  '80304b9c306ea799327f01d9a7549bdb28317789182631f1b54f4511b4206dd6'
  '5ea7cbac9345271c1ba6abb7d591a7e5ddbf188d21470f103bd450cb981a49d5'
)
validpgpkeys=(
  '678CE3FEE430311596DB8C16F52E98007594C21D' # Björn 'besser82' Esser (besser82@fedoraproject.org) <besser82@fedoraproject.org>
)
dependencies=(
  libc
)

build() {
  # local CC="gcc" # ERROR 2025/10/29
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --enable-hashes=strong,glibc
    --enable-obsolete-api=no
    --disable-static
    --disable-failure-tokens
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
