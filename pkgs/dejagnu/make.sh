name="dejagnu"
version="1.6.3"
release="1"
sources=(
  https://ftp.gnu.org/gnu/dejagnu/dejagnu-$version.tar.gz{,.sig}
)
validpgpkeys=(
  'CE9D6843AABACC90' # Jacob Bachmeyer (2021 DejaGnu Release Signing Key) <jcb@gnu.org>
)
dependencies=(
  bash
  expect
)

build() {
  local configure_options=(
    --prefix=/usr
  )

  mkdir -v build && cd build

  ../configure "${configure_options[@]}"

  makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
  makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi
}

package() {
  cd build

  make DESTDIR="$pkgdir" install

  install -vdm755 $pkgdir/usr/share/doc/dejagnu
  install -vm644 doc/dejagnu.{html,txt} $pkgdir/usr/share/doc/dejagnu
}
