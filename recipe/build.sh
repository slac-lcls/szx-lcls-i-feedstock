#!/bin/bash -x -e

declare -a CMAKE_PLATFORM_FLAGS
CMAKE_PLATFORM_FLAGS+=(-DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX}/${HOST}/sysroot")
CMAKE_PLATFORM_FLAGS+=(-DCMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES:PATH="${BUILD_PREFIX}/${HOST}/sysroot/usr/include")

if [[ ${DEBUG_C} == yes ]]; then
  CMAKE_BUILD_TYPE=Debug
else
  CMAKE_BUILD_TYPE=Release
fi


export LDFLAGS="-lrt"
export PKG_CONFIG_PATH=${CONDA_PREFIX}/share/pkgconfig:${CONDA_PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH

env |sort

mkdir build
cd build
${CONDA_PREFIX}/bin/cmake --version
${CONDA_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DSZx_INSTALL_CLI=ON \
  -DSZx_INSTALL_EXAMPLES=ON \
  -DSZx_BUILD_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES=75 \
  "${SRC_DIR}"

${CONDA_PREFIX}/bin/make -j${CPU_COUNT}
${CONDA_PREFIX}/bin/make install PREFIX=${PREFIX}
