# Baltic_OM4_025

### Running example

Pre-requisite:  Please make sure to follow all instructions in the main directory README.md file including compiling all executables and linking the datasets.

1. We now have to set-up the grid.

a. (Optional) If you are on a system that has access to the FMS/FRE tools, you can build your own grids and exchange grids (these tools are available on NOAA/GFDL github: FRE-NCtools).  See the GRID directory for some ideas of how these grids can be created to work with the wave model.  You would need to run the BuildExchangeGrid.csh first and WaveMosaics.py (cshell and python) scripts both to create all necesssary files (there are some pseudo-hacks needed to set-up the grid_spec.nc and the wave related exchange grids, if you are having trouble getting the wind into the wave model this grid_spec step is critical). The exchange grids can be generated at INPUT/EXCHANGE_GRIDS. To run BuildExchangeGrid.csh, you have to copy the BUildExchangeGrid.csh at INPUT/ExchangeGrids and make some edits with the correct fre/bronx version. Also, You might not want to run this on a single login node, it is highly recommended to run this on parallel (using r.g. srun --ntasks=30 make_coupler_mosaic_parallel replacing make_coupler_mosaic). After running the BuildExchangeGrid.csh, you will obtain an updated file named with grid_spec_waves.nc. Replace the contents of the original grid_spec.nc file in the OM4_025.JRA/INPUT/ directory with the contents of grid_spec_waves.nc while keeping file name as grid_spec.nc. Alternatively, you can simply create a symbolic link in the OM4_025.JRA/INPUT/ directory using the following command: ln -s EXCHANGE_GRIDS/grid_spec_waves.nc grid_spec.nc. But, this is all optional, you can simply run with the example here to have a 0p25 degree resolution case on the MOM6 native 1/4 degree grid.  

b. You will need to update the WW3 grid files in WW3/PreProc, see WW3/PreProc/GenGrid.py for an example (this script should create the basic files for you without modification). This generates the WW3 Depth grid for a curvilinear tripolar grid on the MOM6 native 1/4 degree grid.  
> cd WW3/PreProc  
> python GenGrid.py

c. Next you need to create the mod_def.ww3 file for WW3's internal grid:  
> cd WW3/PreProc  
> ../../../../build/ncrc6.intel23/WW3exec/REPRO/bin/ww3_grid

Please replace "ncrc6.intel23" with your compiler environment.

2. Next step is to create a RESTART directory within the example directory:  
> mkdir RESTART  

3.  Now we should be ready to run.  To run on Gaea we can either submit a job through the batch system, or run the job interactively.  In this example we are going to run it interactively.

Gaea Instructions:  
> salloc --clusters=c6 --qos=normal --nodes=1 --x11  
> srun -n 20 ../../build/ncrc6.intel23/wave_ice_ocean/REPRO/MOM6

4.  If this works, then congratulations, you have successful set-up, compiled, and run this example.

In C6 platform, if you encountered any problems with "fatal OVERFLOW buffer list exhausted", try to use the code in the directory of Examples/OM4_025.JRA before you run the case:

>export FI_CXI_RX_MATCH_MODE=hybrid

If the error stays, you might need to try to run with a different core number (e.g. try with srun -n 400 or 600). There is much more we can do with this including customizing set-ups, and processing and manipulating output.  Adding more instructions to this README.md is always welcome!

5. Basic instructions for creating WW3 output files:  MOM6 creates output in an easy to use netCDF format, but WW3 output is stored as binary files which need a further processing step to convert to netCDF.  You should have all the tools to do this already in place.  All you need to do is navigate to WW3/PostProc, and find the build/intel/wave_ice_ocean/ww3_ounf/ww3_ounf executable.  If you run it in this place, the proper files should already be linked to create netCDF from the mod_def and out_grd files.  Note that the ww3_ounf.nml can be edited (along with ww3_multi.nml) to specify diagnostics to save and frequency.  More information can be found in the WW3 directory.
