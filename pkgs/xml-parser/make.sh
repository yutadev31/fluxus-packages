name="xml-parser"
version="2.47"
release="1"
sources=(
  https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-$version.tar.gz
)

build() {
  perl Makefile.PL
  make
}

test() {
  make test
}

package() {
  make DESTDIR="$pkgdir" install
}
