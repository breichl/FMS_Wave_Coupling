#!/bin/tcsh
#
module use -a /ncrc/home2/fms/local/modulefiles
module unload fre-nctools

module load fre-nctools-parallel/2024.04
set echo

echo "calling make_solo_mosaic to create mosaic files (ocean, atmos, land, wave)"
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name ocean_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name atmos_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name land_mosaic --tile_file ocean_hgrid.nc --periodx 360 --periody 360
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name wave_mosaic --tile_file wave_hgrid.nc --periodx 360 --periody 360

echo "make_solo_mosaic call DONE!"
echo "  "
echo "calling make_topog_parallel"
#parallel running can greatly speed up (particularly the coupler_mosaic). 
#You need to be careful about the number of cores used. Inproper number might induce buildexchange grid error.
srun --ntasks=30 make_coupler_mosaic_parallel --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic wave_mosaic.nc --ocean_topog wave_topog.nc --mosaic_name grid_spec --check --print_memory --verbose
#(The above command gives you: atmos_mosaic_tile1Xland_mosaic_tile1.nc,atmos_mosaic_tile1Xwave_mosaic_tile1.nc,land_mosaic_tile1Xwave_mosaic_tile1.nc)

srun --ntasks=30 make_coupler_mosaic_parallel --atmos_mosaic atmos_mosaic.nc --land_mosaic land_mosaic.nc --ocean_mosaic ocean_mosaic.nc --wave_mosaic wave_mosaic.nc --ocean_topog ocean_topog.nc --mosaic_name grid_spec --check --print_memory --verbose
#(The above command overwrite the file atmos_mosaic_tile1Xland_mosaic_tile1.nc and gives you new files: atmos_mosaic_tile1Xocean_mosaic_tile1.nc,land_mosaic_tile1Xocean_mosaic_tile1.nc,wave_mosaic_tile1Xocean_mosaic_tile1.nc)
