name="kmod"
version="34.2"
release="1"
sources=(
  https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-$version.tar{.xz,.sign}
)
# https://www.kernel.org/pub/linux/utils/kernel/kmod/sha256sums.asc
sha256sums=(
  '5a5d5073070cc7e0c7a7a3c6ec2a0e1780850c8b47b3e3892226b93ffcb9cb54'
  'SKIP'
)
validpgpkeys=(
  'EAB33C9690013C733916AC839BA2A5A630CBEA53' # Lucas De Marchi <lucas.demarchi@intel.com>
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
    -D manpages=false
    -D c_args="$CFLAGS"
  )

  meson setup . build "${meson_options[@]}"
  meson compile -C build
}

package() {
  meson install -C build --no-rebuild --destdir $pkgdir --quiet
}
