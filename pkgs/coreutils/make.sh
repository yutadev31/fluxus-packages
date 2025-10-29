name="coreutils"
version="9.8"
release="1"
sources=(
  https://ftp.gnu.org/gnu/coreutils/coreutils-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '6C37DC12121A5006BC1DB804DF6FD971306037D9' # Pádraig Brady <P@draigBrady.com>
)
dependencies=(
  acl
  attr
  libc
  gmp
  libcap
  openssl
)

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    --with-openssl
    --enable-no-install-program=kill,uptime
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  install -vdm755 $pkgdir/usr/share/man/man8
  mv -v $pkgdir/usr/share/man/man1/chroot.1 $pkgdir/usr/share/man/man8/chroot.8
  sed -i 's/"1"/"8"/' $pkgdir/usr/share/man/man8/chroot.8
}
