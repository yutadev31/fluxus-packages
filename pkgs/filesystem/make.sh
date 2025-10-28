name="filesystem"
version="1.0.0"
release="1"
sources=()

package() {
  install -vdm755 $pkgdir/boot
  install -vdm755 $pkgdir/dev
  install -vdm755 $pkgdir/etc
  install -vdm755 $pkgdir/home
  install -vdm755 $pkgdir/mnt
  install -vdm755 $pkgdir/opt
  install -vdm755 $pkgdir/proc
  install -vdm700 $pkgdir/root
  install -vdm755 $pkgdir/run
  install -vdm755 $pkgdir/sys
  install -vdm1777 $pkgdir/tmp
  install -vdm755 $pkgdir/usr
  install -vdm755 $pkgdir/usr/bin
  install -vdm755 $pkgdir/usr/include
  install -vdm755 $pkgdir/usr/lib
  install -vdm755 $pkgdir/usr/lib64
  install -vdm755 $pkgdir/usr/share/licenses
  install -vdm755 $pkgdir/usr/share/man/man{1,2,3,4,5,6,7,8}
  ln -vs usr/bin $pkgdir/bin
  ln -vs usr/lib $pkgdir/lib
  ln -vs usr/lib64 $pkgdir/lib64
  ln -vs usr/bin $pkgdir/sbin
  ln -vs usr/bin $pkgdir/usr/sbin
}
