name="vim"
version="9.1.1871"
release="1"
sources=(
  https://github.com/vim/vim/archive/v$version/vim-$version.tar.gz
)

prepare() {
  echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >>src/feature.h
}

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  ln -vs vim $pkgdir/usr/bin/vi
  for L in $pkgdir/usr/share/man/{,*/}man1/vim.1; do
    ln -vs vim.1 $(dirname $L)/vi.1
  done
}
