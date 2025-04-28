#!/bin/csh

set version=REPRO
set platform="ncrc6.intel23"
set rootdir = `dirname $0`
set rootpath = `pwd`
source ${rootdir}/envs.${platform}


mkdir -p build/${platform}/WW3exec/$version
cd build/${platform}/WW3exec/$version;
cmake ../../../../src/WW3 -DSWITCH=${rootpath}/src/WW3/model/bin/switch_NCEP_st4 -DCMAKE_INSTALL_PREFIX=install
cmake --build . --target ww3_grid ww3_ounf ww3_multi ww3_prnc ww3_strt
