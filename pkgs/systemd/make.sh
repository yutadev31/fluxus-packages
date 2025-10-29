name="systemd"
version="258.1"
release="1"
sources=(
  https://github.com/systemd/systemd/archive/v$version/systemd-$version.tar.gz
)

prepare() {
  sed -i -e 's/GROUP="render"/GROUP="video"/' -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
}

build() {
  local CC="clang"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local meson_options=(
    --prefix=/usr
    --libexecdir=lib
    --sbindir=bin
    --auto-features=enabled
    --wrap-mode=nodownload
    --buildtype=release
    -D default-dnssec=no
    -D firstboot=false
    -D install-tests=false
    -D ldconfig=false
    -D man=auto
    -D sysusers=false
    -D rpmmacrosdir=no
    -D homed=disabled
    -D userdb=false
    -D mode=release
    -D pam=enabled
    -D pamconfdir=/etc/pam.d
    -D dev-kvm-mode=0660
    -D nobody-group=nogroup
    -D sysupdate=disabled
    -D ukify=disabled
    -D selinux=disabled
    -D xenctrl=disabled
    -D bootloader=disabled
    -D c_args="$CFLAGS"
  )

  CC="$CC" meson setup . build "${meson_options[@]}"
  meson compile -C build
}

package() {
  meson install -C build --no-rebuild --destdir $pkgdir --quiet

  cat >>$pkgdir/etc/pam.d/system-session <<EOF
session  required    pam_loginuid.so
session  optional    pam_systemd.so
EOF

  cat >$pkgdir/etc/pam.d/systemd-user <<EOF
account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so
EOF
}
