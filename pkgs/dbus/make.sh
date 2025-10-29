name="dbus"
version="1.16.2"
release="1"
sources=(
  https://dbus.freedesktop.org/releases/dbus/dbus-$version.tar.xz{,.asc}
)
sha256sums=(
  '0ba2a1a4b16afe7bceb2c07e9ce99a8c2c3508e5dec290dbb643384bd6beb7e2'
  'SKIP'
)
validpgpkeys=(
  '7A073AD1AE694FA25BFF62E5235C099D3EB33076' # Simon McVittie <smcv@pseudorandom.co.uk>
)

build() {
  local LD="ld.lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local meson_options=(
    --prefix=/usr
    --buildtype=release
    --wrap-mode=nofallback
    -D c_args="$CFLAGS"
  )

  CC="$CC" meson setup . build "${meson_options[@]}"
  meson compile -C build
}

package() {
  meson install -C build --no-rebuild --destdir $pkgdir --quiet
  ln -vs /etc/machine-id $pkgdir/var/lib/dbus
}
