name="gdbm"
version="1.26"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gdbm/gdbm-$version.tar.gz{,.sig}
)
validpgpkeys=(
  '4BE4E62655488EB92ABB468F79FFD94BFCE230B1' # Sergey Poznyakoff <gray@gnu.org.ua>
)
dependencies=(
  sh
  libc
  readline
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --enable-libgdbm-compat
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
