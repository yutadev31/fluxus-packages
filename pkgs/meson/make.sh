name="meson"
version="1.9.1"
release="1"
sources=(
  https://github.com/mesonbuild/meson/releases/download/$version/meson-$version.tar.gz{,.asc}
)
validpgpkeys=(
  '60411304C09D36628340EEFFCEB167EFB5722BD6' # Eli Schwartz <eschwartz@archlinux.org>
)
dependencies=(
  bash
  ninja
  python
  python-tqdm
)

build() {
  pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
}

package() {
  pip3 install --no-index --find-links dist meson
  install -vDm644 data/shell-completions/bash/meson $pkgdir/usr/share/bash-completion/completions/meson
  install -vDm644 data/shell-completions/zsh/_meson $pkgdir/usr/share/zsh/site-functions/_meson
}
