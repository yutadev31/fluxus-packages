name="glibc"
version="2.42"
release="1"
sources=(
  https://ftp.gnu.org/gnu/glibc/glibc-$version.tar.xz{,.sig}
  https://www.linuxfromscratch.org/patches/lfs/12.4/glibc-$version-fhs-1.patch
)
validpgpkeys=(
  'FD19E6D31B192EE4DC63EAD3DC2B16215ED5412A' # Andreas K. Huettel (at work) <mail@akhuettel.de>
)
dependencies=(
  filesystem
  linux
)

prepare() {
  patch -Np1 -i ./glibc-$version-fhs-1.patch

  sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
    __libc_rwlock_define_initialized (, reset_lock);\
    memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c
}

build() {
  # local CC="clang" # ERROR 2025/10/29
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    --disable-werror
    --disable-nscd
    --enable-stack-protector=strong
    --enable-kernel=6.0
    CFLAGS="$CFLAGS"
  )

  mkdir -v build && cd build

  echo "slibdir=/usr/lib" >>configparms
  echo "rtlddir=/usr/lib" >>configparms
  echo "sbindir=/usr/bin" >>configparms
  echo "rootsbindir=/usr/bin" >>configparms

  ../configure "${configure_options[@]}"

  make
}

test() {
  cd build

  make check
}

package() {
  cd build

  install -vdm755 $pkgdir/etc
  touch $pkgdir/etc/ld.so.conf

  make DESTDIR="$pkgdir" install

  sed '/RTLDLIST=/s@/usr@@g' -i $pkgdir/usr/bin/ldd

  install -vdm755 $pkgdir/usr/lib64
  ln -vsf ../lib/ld-linux-x86-64.so.2 $pkgdir/usr/lib64
  ln -vsf ../lib/ld-linux-x86-64.so.2 $pkgdir/usr/lib64/ld-lsb-x86-64.so.3
}
