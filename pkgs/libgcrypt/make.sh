name="libgcrypt"
version="1.11.2"
release="1"
sources=(
  https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$version.tar.bz2{,.sig}
)
validpgpkeys=(
  '6DAA6E64A76D2840571B4902528897B826403ADA' # Werner Koch (dist signing 2020)
  'AC8E115BF73E2D8D47FA9908E98E9B2D19C6C8BD' # Niibe Yutaka (GnuPG Release Key)
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

  make -C doc html
  makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi
  makeinfo --plaintext -o doc/gcrypt.txt doc/gcrypt.texi
}

package() {
  make DESTDIR="$pkgdir" install

  install -v -dm755 $pkgdir/usr/share/doc/libgcrypt
  install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} $pkgdir/usr/share/doc/libgcrypt
  install -v -dm755 $pkgdir/usr/share/doc/libgcrypt/html
  install -v -m644 doc/gcrypt.html/* $pkgdir/usr/share/doc/libgcrypt/html
  install -v -m644 doc/gcrypt_nochunks.html $pkgdir/usr/share/doc/libgcrypt
  install -v -m644 doc/gcrypt.{txt,texi} $pkgdir/usr/share/doc/libgcrypt
}
