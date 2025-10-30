name="inetutils"
version="2.6"
release="1"
sources=(
  https://ftp.gnu.org/gnu/inetutils/inetutils-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'A3CC9C870B9D310ABAD4CF2F51722B08FE4745A2' # Simon Josefsson <simon@josefsson.org>
)
dependencies=(
  libc
  libcap
  libxcrypt
  ncurses
  pam
  readline
)

prepare() {
  sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
}

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --bindir=/usr/bin
    --localstatedir=/var
    --disable-logger
    --disable-whois
    --disable-rcp
    --disable-rexec
    --disable-rlogin
    --disable-rsh
    --disable-servers
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install
}
