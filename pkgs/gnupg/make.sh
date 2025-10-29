name="gnupg"
version="2.5.13"
release="1-dev"
sources=(
  https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$version.tar.bz2{,.sig}
)
validpgpkeys=(
  '6DAA6E64A76D2840571B4902528897B826403ADA' # Werner Koch (dist signing 2020)
)
dependencies=(
  libassuan
  libgcrypt
  libksba
  npth
  openldap
  gnu-tls
  pinentry
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --localstatedir=/var
    --sysconfdir=/etc
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  mkdir -v build && cd build

  ../configure "${configure_options[@]}"

  make

  makeinfo --html --no-split -I doc -o doc/gnupg_nochunks.html ../doc/gnupg.texi
  makeinfo --plaintext -I doc -o doc/gnupg.txt ../doc/gnupg.texi
  make -C doc html
}

package() {
  make DESTDIR="$pkgdir" install

  install -vdm755 $pkgdir/usr/share/doc/gnupg/html
  install -vm644 doc/gnupg_nochunks.html $pkgdir/usr/share/doc/gnupg/html/gnupg.html
  install -vm644 ../doc/*.texi doc/gnupg.txt $pkgdir/usr/share/doc/gnupg
  install -vm644 doc/gnupg.html/* $pkgdir/usr/share/doc/gnupg/html
  install -vm644 doc/gnupg.pdf $pkgdir/usr/share/doc/gnupg
}
