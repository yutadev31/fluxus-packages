name="bind"
version="9.20.14"
release="1"
sources=(
  https://ftp.isc.org/isc/bind9/$version/bind-$version.tar.xz{,.asc}
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make -C lib/isc
  make -C lib/dns
  make -C lib/ns
  make -C lib/isccfg
  make -C lib/isccc
  make -C bin/dig
  make -C bin/nsupdate
  make -C bin/rndc
  make -C doc
}

package() {
  make DESTDIR="$pkgdir" -C lib/isc install
  make DESTDIR="$pkgdir" -C lib/dns install
  make DESTDIR="$pkgdir" -C lib/ns install
  make DESTDIR="$pkgdir" -C lib/isccfg install
  make DESTDIR="$pkgdir" -C lib/isccc install
  make DESTDIR="$pkgdir" -C bin/dig install
  make DESTDIR="$pkgdir" -C bin/nsupdate install
  make DESTDIR="$pkgdir" -C bin/rndc install

  install -vdm755 $pkgdir/usr/share/man/man1
  cp -v doc/man/{dig.1,host.1,nslookup.1,nsupdate.1} $pkgdir/usr/share/man/man1

  install -vdm755 $pkgdir/usr/share/man/man8
  cp -v doc/man/rndc.8 $pkgdir/usr/share/man/man8
}
