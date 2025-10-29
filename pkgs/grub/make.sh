name="grub"
version="2.12"
release="2"
sources=(
  https://ftp.gnu.org/gnu/grub/grub-$version.tar.xz{,.sig}
)
validpgpkeys=(
  'BE5C23209ACDDACEB20DB0A28C8189F1988C2166' # Daniel Kiper <dkiper@net-space.pl>
)
dependencies=(
  sh
  device-mapper
  gettext
  xz
)

build() {
  echo dependencies bli part_gpt >grub-core/extra_deps.lst

  local configure_options=(
    --prefix=/usr
    --sbindir=/usr/bin
    --sysconfdir=/etc
    --disable-efiemu
    --disable-werror
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
  mv $pkgdir/usr/sbin/* $pkgdir/usr/bin
  rm -rf $pkgdir/usr/sbin

  install -vdm755 $pkgdir/usr/share/bash-completion/completions
  mv -v $pkgdir/etc/bash_completion.d/grub $pkgdir/usr/share/bash-completion/completions
}
