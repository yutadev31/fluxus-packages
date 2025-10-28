name="iana-etc"
version="20251022"
release="1"
sources=(
  https://github.com/Mic92/iana-etc/releases/download/$version/iana-etc-$version.tar.gz
)
sha256sums=(
  '4b944a355b326941a9ffb4461c98a746f148ec320449e919400467f8598c5479'
)

package() {
  install -vdm755 $pkgdir/etc
  cp -v services protocols $pkgdir/etc
}
