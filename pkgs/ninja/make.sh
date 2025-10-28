name="ninja"
version="1.13.1"
release="1"
sources=(
  https://github.com/ninja-build/ninja/archive/v$version/ninja-$version.tar.gz
)
dependencies=(
  gcc
)

prepare() {
  sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
}

build() {
  export NINJAJOBS="$(nproc)"

  python3 configure.py --bootstrap --verbose
}

package() {
  install -vdm755 $pkgdir/usr/bin $pkgdir/usr/share/bash-completion/completions $pkgdir/usr/share/zsh/site-functions

  install -vm755 ninja $pkgdir/usr/bin/
  install -vDm644 misc/bash-completion $pkgdir/usr/share/bash-completion/completions/ninja
  install -vDm644 misc/zsh-completion $pkgdir/usr/share/zsh/site-functions/_ninja
}
