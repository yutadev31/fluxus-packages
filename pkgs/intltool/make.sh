name="intltool"
version="0.51.0"
release="1"
sources=(
  https://launchpad.net/intltool/trunk/$version/+download/intltool-$version.tar.gz{,.asc}
)
md5sums=(
  '12e517cac2b57a0121cda351570f1e63'
  'SKIP'
)
validpgpkeys=(
  'E1A701D4C9DE75B5' # Rodney Dawes (Canonical) <rodney.dawes@canonical.com>
)
dependencies=(
  xml-parser
)

prepare() {
  sed -i 's:\\\${:\\\$\\{:' intltool-update.in
}

build() {
  # TODO
  local configure_options=(
    --prefix=/usr
  )

  ./configure "${configure_options[@]}"

  make
}

test() {
  make check
}

package() {
  make DESTDIR="$pkgdir" install

  install -vDm644 doc/I18N-HOWTO $pkgdir/usr/share/doc/intltool/I18N-HOWTO
}
