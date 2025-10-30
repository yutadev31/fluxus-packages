name="llvm"
version="21.1.4"
release="1-dev"
sources=(
  https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$version.tar.gz
)

build() {
  local CC="gcc"
  local CXX="g++"
  local cmake_options=(
    -D CMAKE_INSTALL_PREFIX=/usr
    -D CMAKE_SKIP_INSTALL_RPATH=ON
    -D LLVM_ENABLE_FFI=ON
    -D CMAKE_BUILD_TYPE=Release
    -D LLVM_BUILD_LLVM_DYLIB=ON
    -D LLVM_LINK_LLVM_DYLIB=ON
    -D LLVM_ENABLE_RTTI=ON
    -D LLVM_TARGETS_TO_BUILD="host;AMDGPU"
    -D LLVM_BINUTILS_INCDIR=/usr/include
    -D LLVM_INCLUDE_BENCHMARKS=OFF
    -D CLANG_DEFAULT_PIE_ON_LINUX=ON
    -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang
    -W no-dev -G Ninja
  )

  mkdir -v build && cd build

  CC="$CC" CXX="$CXX" cmake "${cmake_options[@]}" ../llvm

  ninja
}

package() {
  cd build

  DESTDIR="$pkgdir" ninja install
}
