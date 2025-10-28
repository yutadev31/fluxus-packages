name="texinfo"
version="7.2"
release="1"
sources=(
  https://ftp.gnu.org/gnu/texinfo/texinfo-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'EAF669B31E31E1DECBD11513DDBC579DAB37FBA9' # Gavin Smith (Texinfo maintainer) <GavinSmith0123@gmail.com>
)

prepare() {
  sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm
}

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
  make DESTDIR="$pkgdir" TEXMF=/usr/share/texmf install-tex
}
