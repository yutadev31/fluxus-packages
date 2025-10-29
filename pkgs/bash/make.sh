name="bash"
_basever="5.3"
_patchver="3"
version="${_basever}.${_patchver}"
release="1"
sources=(
  https://ftp.gnu.org/gnu/bash/bash-$_basever.tar.gz{,.sig}
)
validpgpkeys=(
  '7C0135FB088AAF6C66C650B9BB5869F064EA74AB' # Chet Ramey <chet@cwru.edu>
)
dependencies=(
  libc
  ncurses
  readline
)
opt_dependencies=(
  bash-completion
)
provides=(
  sh
)

if [[ 0 != $_patchver ]]; then
  for i in $(seq 1 ${_patchver}); do
    sources=(
      "${sources[@]}"
      https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-$(printf "%03d" $i){,.sig}
    )
  done
fi

prepare() {
  if [[ 0 != $_patchver ]]; then
    for i in $(seq 1 ${_patchver}); do
      patch -Np0 -i ./bash${_basever//./}-$(printf "%03d" $i)
    done
  fi
}

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --without-bash-malloc
    --with-installed-readline
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make tests
}

package() {
  make DESTDIR="$pkgdir" install
  ln -vs bash $pkgdir/usr/bin/sh
  ln -vs bash $pkgdir/usr/bin/rbash
}
