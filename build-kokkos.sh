#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${LIBHPX:?} ${BUILD_TYPE:?} \
    ${CMAKE_VERSION:?} ${CMAKE_COMMAND:?} ${OCT_WITH_CUDA:?} ${CUDA_SM:?} \
    ${BOOST_VERSION:?} ${BOOST_BUILD_TYPE:?} \
    ${JEMALLOC_VERSION:?} ${HWLOC_VERSION:?} ${VC_VERSION:?} ${HPX_VERSION:?} \
    ${OCT_WITH_PARCEL:?}

DIR_SRC=${SOURCE_ROOT}/kokkos
DIR_BUILD=${INSTALL_ROOT}/kokkos/build
DIR_INSTALL=${INSTALL_ROOT}/kokkos

if [[ ! -d ${DIR_SRC} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
	cd ..
        #git clone https://github.com/STEllAR-GROUP/hpx.git
	git clone https://github.com/kokkos/kokkos kokkos
	cd kokkos
	git checkout 2.9.00
	git am < ../../0001-Add-dumpversion-option-to-nvcc_wrapper.patch
	cd ..
    )
fi

${CMAKE_COMMAND} \
	-H${DIR_SRC} \
	-B${DIR_BUILD} \
       	-DKOKKOS_ENABLE_CUDA=${OCT_WITH_CUDA} \
        -DKOKKOS_ARCH=Pascal61 \
       	-DKOKKOS_ENABLE_SERIAL=1 \
	-DCMAKE_CXX_FLAGS="-isystem ${INSTALL_ROOT}/hpx/include" \
       	-DKOKKOS_ENABLE_HPX=1 \
	-DKokkos_HPX_DIR=${INSTALL_ROOT}/hpx/build/lib/cmake/HPX \
       	-DHPX_DIR=${INSTALL_ROOT}/hpx/build/lib/cmake/HPX \
       	-DCMAKE_CXX_COMPILER=${SOURCE_ROOT}/kokkos/bin/nvcc_wrapper \
       	-DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT}/kokkos/install

${CMAKE_COMMAND} --build ${DIR_BUILD} -- -j${PARALLEL_BUILD} VERBOSE=1

