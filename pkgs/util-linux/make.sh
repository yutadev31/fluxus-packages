name="util-linux"
version="2.41.2"
_base_ver="$(echo "$version" | cut -d '.' -f 1-2)"
release="1"
sources=(
  https://www.kernel.org/pub/linux/utils/util-linux/v$_base_ver/util-linux-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/utils/util-linux/v2.41/sha256sums.asc
sha256sums=(
  '6062a1d89b571a61932e6fc0211f36060c4183568b81ee866cf363bce9f6583e'
  'SKIP'
)
validpgpkeys=(
  'B0C64D14301CC6EFAEDF60E4E4B71D5EEC39C284' # Karel Zak <kzak@redhat.com>
)
dependencies=(
  coreutils
  file
  libc
  libxcrypt
  ncurses
  pam
  readline
  shadow
  systemd
  zlib
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --bindir=/usr/bin
    --libdir=/usr/lib
    --runstatedir=/run
    --sbindir=/usr/sbin
    --disable-chfn-chsh
    --disable-login
    --disable-nologin
    --disable-su
    --disable-setpriv
    --disable-runuser
    --disable-pylibmount
    --disable-liblastlog2
    --disable-static
    --without-python
    ADJTIME_PATH=/var/lib/hwclock/adjtime
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
