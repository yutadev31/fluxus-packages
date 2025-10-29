name="gcc"
version="15.2.0"
release="1"
sources=(
  https://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '7F74F97C103468EE5D750B583AB00996FC26A641' # Richard Guenther <richard.guenther@gmail.com>
)
dependencies=(
  binutils
  libisl
  libmpc
  zstd
)

prepare() {
  sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
}

build() {
  local CC="gcc"
  local CXX="g++"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local CXXFLAGS="$CFLAGS"
  local configure_options=(
    --prefix=/usr
    --libdir=/usr/lib
    --libexecdir=/usr/lib
    --mandir=/usr/share/man
    --infodir=/usr/share/info
    --enable-languages=c,c++
    --enable-default-pie
    --enable-default-ssp
    --enable-host-pie
    --disable-multilib
    --disable-bootstrap
    --disable-fixincludes
    --with-system-zlib
    CC="$CC"
    CXX="$CXX"
    CFLAGS="$CFLAGS"
    CXXFLAGS="$CXXFLAGS"
  )

  mkdir -v build && cd build

  ../configure "${configure_options[@]}"

  make
}

package() {
  cd build

  make DESTDIR="$pkgdir" install

  ln -vsr /usr/bin/cpp $pkgdir/usr/lib
  ln -vs gcc $pkgdir/usr/bin/cc
  ln -vs gcc.1 $pkgdir/usr/share/man/man1/cc.1

  install -vdm755 $pkgdir/usr/lib/bfd-plugins/
  ln -vs /usr/lib/liblto_plugin.so $pkgdir/usr/lib/bfd-plugins/liblto_plugin.so
}
