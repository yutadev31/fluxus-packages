name="pcre2"
version="10.47"
release="1"
sources=(
  https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$version/pcre2-$version.tar.bz2{,.sig}
)
sha256sums=(
  '47fe8c99461250d42f89e6e8fdaeba9da057855d06eb7fc08d9ca03fd08d7bc7'
  '9f66addba680d709691fa3c472bd46bbd3e08c25ac881e1aaa67822f6a32cf89'
)
validpgpkeys=(
  'BACF71F10404D5761C09D392021DE40BFB63B406' # Nicholas Wilson <nicholas@nicholaswilson.me.uk>
)

build() {
  local CC="gcc"
  local CFLAGS="-O2 -pipe $AVX_LEVEL -march=$MARCH_LEVEL -mtune=$MTUNE_LEVEL"
  local configure_options=(
    --prefix=/usr
    --enable-unicode
    --enable-jit
    --enable-pcre2-16
    --enable-pcre2-32
    --enable-pcre2grep-libz
    --enable-pcre2grep-libbz2
    --enable-pcre2test-libreadline
    --disable-static
    CC="$CC"
    CFLAGS="$CFLAGS"
  )

  ./configure "${configure_options[@]}"

  make
}

package() {
  make DESTDIR="$pkgdir" install
}
