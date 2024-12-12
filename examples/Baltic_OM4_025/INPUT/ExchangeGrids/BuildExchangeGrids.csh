#!/bin/tcsh
#

module load fre/bronx-15

make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name ocean_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name atmos_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name land_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name wave_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360

make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic wave_mosaic.nc --ocean_topog wave_topog.nc --mosaic_name grid_spec

cp atmos_mosaic_tile1Xocean_mosaic_tile1.nc atmos_mosaic_tile1Xwave_mosaic_tile1.nc

make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic ocean_mosaic.nc --wave_mosaic wave_mosaic.nc --ocean_topog ocean_topog.nc --mosaic_name grid_spec
