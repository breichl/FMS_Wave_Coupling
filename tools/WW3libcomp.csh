#!/bin/csh
#

set version=REPRO
set platform="ncrc6.intel23"
set rootdir = `dirname $0`
set rootpath = `pwd`
source ${rootdir}/envs.${platform}

mkdir -p build/${platform}/ww3lib/$version
cd build/${platform}/ww3lib/$version;
cmake ../../../../src/WW3 -DSWITCH={$rootpath}/src/WW3/model/bin/switch_NCEP_st4 -DCMAKE_INSTALL_PREFIX=install
cmake --build . --target ww3_lib
