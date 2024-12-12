#!/bin/tcsh
#

module load fre/bronx-10
module load PythonEnv-noaa
module load nco/4.5.4

#make_hgrid --grid_type regular_lonlat_grid --nxbnd 2 --nybnd 2 --xbnd 96.5,179 --ybnd 5,42.5 --nlon 660 --nlat 300 --grid_name ocean_hgrid
make_hgrid --grid_type regular_lonlat_grid --nxbnd 2 --nybnd 2 --xbnd 115,135 --ybnd 15,35 --nlon 1120 --nlat 1120 --grid_name ocean_hgrid

make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name ocean_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name atmos_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name land_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name wave_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360

make_topog --mosaic ocean_mosaic.nc --topog_type  rectangular_basin --bottom_depth 4000

make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc  --ocean_mosaic wave_mosaic.nc --ocean_topog topog.nc

cp atmos_mosaic_tile1Xocean_mosaic_tile1.nc atmos_mosaic_tile1Xwave_mosaic_tile1.nc

make_coupler_mosaic --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic ocean_mosaic.nc --wave_mosaic wave_mosaic.nc --ocean_topog topog.nc --mosaic_name grid_spec --check --verbose

ncks -O -x -v nfile_aXl,aXl_file grid_spec.nc grid_spec2.nc
