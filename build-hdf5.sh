#!/bin/bash
set -x
set -e
if [ -z ${octotiger_source_me_sources} ] ; then
   . source-me.sh
   . source-gcc.sh
fi

cd $SOURCE_ROOT
if [ ! -d "hdf5/" ]; then
    git clone https://github.com/live-clones/hdf5
else
    cd hdf5
    git pull
    cd ..
fi
cd hdf5
git checkout hdf5_1_10_4 
cd $INSTALL_ROOT
mkdir -p hdf5 
cd hdf5
mkdir -p build
cd build
$INSTALL_ROOT/cmake/bin/cmake \
      -DCMAKE_C_COMPILER=$CC \
      -DCMAKE_CXX_COMPILER=$CXX \
      -DBUILD_TESTING=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_ROOT/hdf5 \
      $SOURCE_ROOT/hdf5

make -j${PARALLEL_BUILD} VERBOSE=1 install

