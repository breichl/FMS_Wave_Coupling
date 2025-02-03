#!/bin/tcsh
#

module use -a /ncrc/home2/fms/local/modulefiles
module unload fre-nctools

module load fre-nctools-parallel/2024.04

make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name ocean_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name atmos_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name land_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name wave_mosaic --tile_file wave_hgrid.nc --periodx 360 --periody 360

echo "make_solo_mosaic call DONE!"
echo "  "
#These can be run parallel to greatly speed up (particularly the coupler_mosaic)
make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic wave_mosaic.nc --ocean_topog wave_topog.nc --mosaic_name grid_spec

make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic ocean_mosaic.nc --wave_mosaic wave_mosaic.nc --ocean_topog ocean_topog.nc --mosaic_name grid_spec
