name="automake"
version="1.18.1"
release="1"
sources=(
  https://ftp.gnu.org/gnu/automake/automake-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '17D3311B14BC0F248267BF020716748A30D155AD' # Karl Berry <karl@freefriends.org>
)
dependencies=(
  bash
  perl
)

build() {
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
}
