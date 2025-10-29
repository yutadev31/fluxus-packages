name="perl"
version="5.42.0"
release="1"
sources=(
  https://www.cpan.org/src/${version%%.*}.0/perl-$version.tar.xz
)
sha256sums=(
  '73cf6cc1ea2b2b1c110a18c14bbbc73a362073003893ffcedc26d22ebdbdd0c3'
)
dependencies=(
  gdbm
  libc
  libxcrypt
)

build() {
  export BUILD_ZLIB=False
  export BUILD_BZIP2=0

  # TODO local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local libdir=/usr/lib/perl${version%%.*}/$(echo "$version" | cut -d '.' -f 1-2)
  local configure_options=(
    -des
    -D prefix=/usr
    -D vendorprefix=/usr
    -D privlib=$libdir/core_perl
    -D archlib=$libdir/core_perl
    -D sitelib=$libdir/site_perl
    -D sitearch=$libdir/site_perl
    -D vendorlib=$libdir/vendor_perl
    -D vendorarch=$libdir/vendor_perl
    -D man1dir=/usr/share/man/man1
    -D man3dir=/usr/share/man/man3
    -D pager="/usr/bin/less -isR"
    -D useshrplib
    -D usethreads
    -D ccflags="$CFLAGS"
  )

  sh Configure "${configure_options[@]}"

  make
}

test() {
  TEST_JOBS=$(nproc) make test_harness
}

package() {
  make DESTDIR="$pkgdir" install
  unset BUILD_ZLIB BUILD_BZIP2
}
