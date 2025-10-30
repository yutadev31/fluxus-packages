name="git"
version="2.51.1"
release="1"
sources=(
  https://www.kernel.org/pub/software/scm/git/git-$version.tar{.xz,.sign}
)
validpgpkeys=(
  'E1F036B1FEE7221FC778ECEFB0B5E88696AFE6CB' # Junio C Hamano <gitster@pobox.com>
)
dependencies=(
  curl
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --with-gitconfig=/etc/gitconfig
    --with-python=python3
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
