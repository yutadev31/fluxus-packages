name="libpsl"
version="0.21.5"
release="1"
sources=(
  https://github.com/rockdaboot/libpsl/releases/download/$version/libpsl-$version.tar.gz{,.sig}
)
validpgpkeys=(
  '1CB27DBC98614B2D5841646D08302DB6A2670428' # Tim Rühsen <tim.ruehsen@gmx.de>
)
dependencies=(
  libidn2
  libunistring
)

build() {
  local CFLAGS="-O2 -pipe -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local meson_options=(
    --prefix=/usr
    --libexecdir=lib
    --sbindir=bin
    --auto-features=enabled
    --wrap-mode=nodownload
    --buildtype=release
    -D c_args="$CFLAGS"
  )

  meson setup . build "${meson_options[@]}"
  meson compile -C build
}

package() {
  meson install -C build --no-rebuild --destdir $pkgdir --quiet
}
