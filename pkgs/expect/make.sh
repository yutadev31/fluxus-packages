name="expect"
version="5.45.4"
release="1"
sources=(
  https://downloads.sourceforge.net/project/expect/Expect/$version/expect$version.tar.gz
  https://www.linuxfromscratch.org/patches/lfs/12.4/expect-$version-gcc15-1.patch
)
sha256sums=(
  '49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34'
  'SKIP'
)
dependencies=(
  tcl
)

prepare() {
  patch -Np1 -i ./expect-$version-gcc15-1.patch
}

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --with-tcl=/usr/lib
    --enable-shared
    --disable-rpath
    --mandir=/usr/share/man
    --with-tclinclude=/usr/include
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  install -vdm755 $pkgdir/usr/lib
  ln -vs expect5.45.4/libexpect5.45.4.so $pkgdir/usr/lib
}
