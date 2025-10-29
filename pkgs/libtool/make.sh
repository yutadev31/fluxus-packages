name="libtool"
version="2.5.4"
release="1"
sources=(
  https://ftp.gnu.org/gnu/libtool/libtool-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'FA26CA784BE188927F22B99F6570EA01146F7354' # Ileana Dumitrescu <ileanadumi95@protonmail.com>
)
dependencies=(
  sh
  libc
  tar
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
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
  rm -fv $pkgdir/usr/lib/libltdl.a
}
