name="man-pages"
version="6.15"
release="1"
sources=(
  https://www.kernel.org/pub/linux/docs/man-pages/man-pages-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/docs/man-pages/sha256sums.asc
sha256sums=(
  '03d8ebf618bd5df57cb4bf355efa3f4cd3a00b771efd623d4fd042b5dceb4465'
  'SKIP'
)
validpgpkeys=(
  '4BB26DF6EF466E6956003022EB89995CC290C2A9' # Alejandro Colomar <alx@alejandro-colomar.es>
)

prepare() {
  rm -v man3/crypt*
}

package() {
  make -R DESTDIR="$pkgdir" GIT=false prefix=/usr install
}
