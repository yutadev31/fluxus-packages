name="autoconf"
version="2.72"
release="1"
sources=(
  https://ftp.gnu.org/gnu/autoconf/autoconf-$version.tar.xz{,.sig}
)
validpgpkeys=(
  '82F854F3CE73174B8B63174091FCC32B6769AA64' # Zack Weinberg <zackw@panix.com>
)
dependencies=(
  sh
  awk
  diffutils
  m4
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
