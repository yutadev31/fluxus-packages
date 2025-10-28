name="iproute2"
version="6.17.0"
release="1"
sources=(
  https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/utils/net/iproute2/sha256sums.asc
sha256sums=(
  '9781e59410ab7dea8e9f79bb10ff1488e63d10fcbb70503b94426ba27a8e2dec'
  'SKIP'
)
validpgpkeys=(
  '9F6FC345B05BE7E766B83C8F80A77F6095CDE47E' # Stephen Hemminger (Microsoft corporate) <sthemmin@microsoft.com>
)

prepare() {
  sed -i /ARPD/d Makefile
  rm -fv man/man8/arpd.8
}

build() {
  # TODO local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"

  make NETNS_RUN_DIR=/run/netns # TODO CFLAGS="$CFLAGS"
}

package() {
  make DESTDIR="$pkgdir" SBINDIR=/usr/bin install
  install -vDm644 COPYING README* -t $pkgdir/usr/share/doc/iproute2
}
