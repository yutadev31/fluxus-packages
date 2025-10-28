name="bc"
version="7.0.3"
release="1"
sources=(
  https://github.com/gavinhoward/bc/releases/download/$version/bc-$version.tar.xz{,.sig}
)
sha256sums=(
  '91eb74caed0ee6655b669711a4f350c25579778694df248e28363318e03c7fc4'
  'd06faa5c5441abe2dfd7ec964bec7d2ca99c6fb88aa81ac1541c8dab952fb73f'
)
validpgpkeys=(
  'A10735C205799E14A56E2EDA93D31C8CA4AB6C63' # Gavin D. Howard <gavin@gavinhoward.com>
)
dependencies=(
  readline
)

build() {
  local CC="gcc -std=c99"
  local CFLAGS="-O3 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    CFLAGS="$CFLAGS"
  )

  CC="$CC" ./configure "${configure_options[@]}"

  make
}

test() {
  make test
}

package() {
  make DESTDIR="$pkgdir" install
}
