name="linux"
version="6.17.5"
release="1-dev"
sources=(
  https://cdn.kernel.org/pub/linux/kernel/v${version%%.*}.x/linux-$version.tar.{xz,sign}
  kernel-config
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=(
  'c05faf36e9c2164be723cf6ada8533788804d48f9dd2fe1be2ccee3616a92bce'
  'SKIP'
  'SKIP'
)
validpgpkeys=(
  'ABAF11C65A2970B130ABE3C479BE3E4300411886' # Linus Torvalds <torvalds@kernel.org>
  '647F28654894E3BD457199BE38DBBDC86092693E' # Greg Kroah-Hartman <gregkh@kernel.org>
)
provides=(
  linux-headers
)
dependencies=(
  coreutils
  initramfs
  kmod
)

fetch_latest() {
  json=$(curl -s https://www.kernel.org/releases.json)
  latest_stable=$(echo "$json" | jq -r '.latest_stable.version')
  echo "$latest_stable"
}

prepare() {
  mv kernel-config .config
}

build() {
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"

  make LLVM=1 KCFLAGS="$CFLAGS"
}

package() {
  install -vdm755 $pkgdir/boot
  install -vDm644 "$(make -s image_name)" $pkgdir/boot/vmlinuz-$version
  install -vDm644 System.map $pkgdir/boot/System.map-$version
  install -vDm644 .config $pkgdir/boot/config-$version

  make INSTALL_MOD_PATH=$pkgdir/usr modules_install

  install -vdm755 $pkgdir/etc/modprobe.d
  cat >$pkgdir/etc/modprobe.d/usb.conf <<EOF
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF

  make INSTALL_HDR_PATH=$pkgdir/usr headers_install

  install -vdm755 $pkgdir/usr/share/doc/linux
  cp -vr Documentation/* $pkgdir/usr/share/doc/linux
}
