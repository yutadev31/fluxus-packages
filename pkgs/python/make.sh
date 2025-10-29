name="python"
version="3.13.7"
release="1"
sources=(
  https://www.python.org/ftp/python/$version/Python-$version.tar.xz{,.asc}
)
validpgpkeys=(
  '7169605F62C751356D054A26A821E680E5FA6305' # Thomas Wouters <thomas@python.org>
)
dependencies=(
  bzip2
  expat
  gdbm
  libffi
  libnsl
  libxcrypt
  openssl
  zlib
  tzdata
  mpdecimal
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --enable-shared
    --with-system-expat
    --enable-optimizations
    --without-static-libpython
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make test TESTOPTS="--timeout 120"
}

package() {
  make DESTDIR="$pkgdir" install

  install -vdm755 $pkgdir/etc
  cat >$pkgdir/etc/pip.conf <<EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
}
