name="markupsafe"
version="3.0.2"
release="1"
sources=(
  https://pypi.org/packages/source/M/MarkupSafe/markupsafe-$version.tar.gz
)

build() {
  pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
}

package() {
  pip3 install --no-index --find-links dist Markupsafe
}
