name="sed"
version="4.9"
release="1"
sources=(
  https://ftp.gnu.org/gnu/sed/sed-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '155D3FC500C834486D1EEA677FD9FCCB000BEEEE' # Jim Meyering <jim@meyering.net>
)
dependencies=(
  acl
  libc
)

build() {
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
  make html

}

package() {
  make DESTDIR="$pkgdir" install
}
