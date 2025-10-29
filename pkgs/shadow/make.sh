name="shadow"
version="4.18.0"
release="1"
sources=(
  https://github.com/shadow-maint/shadow/releases/download/$version/shadow-$version.tar.xz{,.asc}
)
validpgpkeys=(
  'A9BD3FF17072B6DB780FCF943570DA17270ACE24' # Serge Hallyn <sergeh@kernel.org>
)
dependencies=(
  acl
  attr
  audit
  libc
  libxcrypt
  pam
)

prepare() {
  sed -i 's/groups$(EXEEXT) //' src/Makefile.in
  find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
  find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
  find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;

  sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:' \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
    -i etc/login.defs
}

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --sysconfdir=/etc
    --disable-static
    --with-{b,yes}crypt
    --without-libbsd
    --with-group-name-max-length=32
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" exec_prefix=/usr install
  make DESTDIR="$pkgdir" -C man install-man

  mv -v $pkgdir/usr/sbin/* $pkgdir/usr/bin
  rm -rfv $pkgdir/usr/sbin
}
