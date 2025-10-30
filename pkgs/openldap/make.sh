name="openldap"
version="2.6.10"
release="1-dev"
sources=(
  https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-$version.tgz{,.asc}
)
validpgpkeys=(
  '3CE269B5398BC8B785645E987F67D5FD1CE1CBCE' # OpenLDAP Project <project@openldap.org>
)

build() {
  local LD="lld"
  local CC="clang"
  local CFLAGS="-O2 -pipe -flto $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL -fuse-ld=$LD"
  local configure_options=(
    --prefix=/usr
    --sysconfdir=/etc
    --localstatedir=/var
    --libexecdir=/usr/lib
    --sbindir=/usr/bin
    --disable-static
    --disable-debug
    --with-tls=openssl
    --with-cyrus-sasl
    --without-systemd
    --enable-dynamic
    --enable-crypt
    --enable-spasswd
    --enable-slapd
    --enable-modules
    --enable-rlookups
    --enable-backends=mod
    --disable-sql
    --disable-wt
    --enable-overlays=mod
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make depend
  make
}

package() {
  make DESTDIR="$pkgdir" install

  sed -e "s/\.la/.so/" -i $pkgdir/etc/openldap/slapd.{conf,ldif}{,.default}
  install -v -dm700 -o ldap -g ldap $pkgdir/var/lib/openldap
  install -v -dm700 -o ldap -g ldap $pkgdir/etc/openldap/slapd.d
  chmod -v 640 $pkgdir/etc/openldap/slapd.{conf,ldif}
  chown -v root:ldap $pkgdir/etc/openldap/slapd.{conf,ldif}
  install -v -dm755 $pkgdir/usr/share/doc/openldap
  cp -vfr doc/{drafts,rfc,guide} $pkgdir/usr/share/doc/openldap
}
