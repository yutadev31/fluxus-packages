name="openssh"
version="10.0p1"
release="1"
sources=(
  https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$version.tar.gz{,.asc}
)
validpgpkeys=(
  '7168B983815A5EEF59A4ADFD2A3F414E736060BA' # Damien Miller <djm@mindrot.org>
)

build() {
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --sysconfdir=/etc/ssh
    --with-privsep-path=/var/lib/sshd
    --with-default-path=/usr/bin
    --with-superuser-path=/usr/bin
    --with-pid-dir=/run
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  install -v -m755 contrib/ssh-copy-id $pkgdir/usr/bin
  install -v -m644 contrib/ssh-copy-id.1 $pkgdir/usr/share/man/man1
  install -v -m755 -d $pkgdir/usr/share/doc/openssh
  install -v -m644 INSTALL LICENCE OVERVIEW README* $pkgdir/usr/share/doc/openssh
}
