name="fpm"
version="0.1.0"
release="1"
description="Fluxus package manager"
sources=(
  https://github.com/yutadev31/fpm/archive/refs/tags/v$version.tar.gz
)

build() {
  cargo build --release
}

package() {
  install -vdm755 "$pkgdir/usr/bin"
  install -vm755 ./target/release/fpm "$pkgdir/usr/bin/fpm"
}
