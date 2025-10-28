name="libcap"
version="2.76"
release="1"
sources=(
  https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/sha256sums.asc
sha256sums=(
  '629da4ab29900d0f7fcc36227073743119925fd711c99a1689bbf5c9b40c8e6f'
  'SKIP'
)
validpgpkeys=(
  '38A644698C69787344E954CE29EE848AE2CCF3F4' # Andrew G. Morgan <morgan@kernel.org>
)
dependencies=(
  glibc
  pam
)

prepare() {
  sed -i '/install -m.*STA/d' libcap/Makefile
}

build() {
  # TODO local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"

  make prefix=/usr lib=lib # TODO CFLAGS="$CFLAGS"
}

package() {
  make DESTDIR="$pkgdir" prefix=/usr lib=lib install
}
