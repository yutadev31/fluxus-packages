name="readline"
version="8.3.1"
_base_ver="$(echo "$version" | cut -d '.' -f 1-2)"
_patch_ver="$(echo "$version" | cut -d '.' -f 3)"
release="1"
sources=(
  https://ftp.gnu.org/gnu/readline/readline-$_base_ver.tar.gz{,.sig}
)
dependencies=(
  glibc
  ncurses
)
validpgpkeys=(
  '7C0135FB088AAF6C66C650B9BB5869F064EA74AB' # Chet Ramey <chet@cwru.edu>
)

if [[ $_patch_ver > 0 ]]; then
  for i in $(seq 1 ${_patch_ver}); do
    sources=(
      "${sources[@]}"
      https://ftp.gnu.org/gnu/readline/readline-$_base_ver-patches/readline${_base_ver//./}-$(printf "%03d" $i){,.sig}
    )
  done
fi

prepare() {
  if [[ $_patch_ver > 0 ]]; then
    for i in $(seq 1 ${_patch_ver}); do
      patch -Np0 -i ./readline${_base_ver//./}-$(printf "%03d" $i)
    done
  fi

  sed -i '/MV.*old/d' Makefile.in
  sed -i '/{OLDSUFF}/c:' support/shlib-install

  sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
}

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --disable-static
    --with-curses
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make SHLIB_LIBS="-lncursesw"
}

package() {
  make DESTDIR="$pkgdir" install
}
