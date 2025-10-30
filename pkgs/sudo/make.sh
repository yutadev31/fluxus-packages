name="sudo"
version="1.9.17p2"
release="1"
sources=(
  https://www.sudo.ws/dist/sudo-$version.tar.gz{,.sig}
)
validpgpkeys=(
  '59D1E9CCBA2B376704FDD35BA9F4C021CEA470FB' # Todd C. Miller <Todd.Miller@sudo.ws>
)

build() {
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --libexecdir=/usr/lib
    --with-secure-path
    --with-env-editor
    --docdir=/usr/share/doc/sudo-1.9.17p2
    --with-passprompt="[sudo] password for %p: "
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install

  cat >$pkgdir/etc/sudoers.d/00-sudo <<"EOF"
%wheel ALL=(ALL) ALL
EOF
}
