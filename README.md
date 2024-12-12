# FMS Wave Coupling: WAVEWATCH III in FMS

### Clone this repository, update submodules.

To clone this repository from github use the following:

> Using https:
> 
> git clone https://github.com/breichl/FMS_Wave_Coupling.git

Download and update the submodules:

> cd FMS_Wave_Coupling  
> git submodule update --init --recursive

Now you should be ready to compile.

### Compiling on Gaea

1. First step is to set up the wave model.  The wave model source code must be pre-processed using WAVEWATCH provided programs to convert to standard FORTRAN 90 files.  A sample script to complete this step is provided in "tools/SetUpWW3.csh", which works on Gaea and GFDL workstations to use a particular switch file and extract FORTRAN 90 code from the WW3 ftn code.  This script sets up code to compile WW3 preprocessor routines for building the grid binary (ww3_grid), the forcing binaries (ww3_prnc, needed for standalone WW3), and the stand alone WW3 driver (ww3_multi).  It also sets up code to compile WW3 postprocessor routines for converting the output binary into NetCDF (ww3_ounf).  Note that the wave model needs to know a valid compiler to unpack its "ftn" files into "f90" files, but you shouldn't need to use the same fortran compiler that you will use to create executables.

> Gaea/GFDL Instructions:
>
> cd FMS_Wave_Coupling  
> ./Set_Up_WW3.csh

2. The second step is to compile.  Again, a script to do this is provided for GFDL and Gaea.  This script will compile 1) FMS library, 2) ww3_grid, 3) ww3_prnc, 4) ww3_multi, 5) WW3 library (for linking within coupled model), 6) the coupled model , and 7) ww3_ounf. You need to create the soft link to the compile file (this works for both C5 and C6 clusters):
>ln -sf tools/FMScomp.csh FMScomp.csh

>ln -sf tools/WW3comp.csh WW3comp.csh

>ln -sf tools/MOM6comp.csh MOM6comp.csh

>ln -sf tools/WW3execcomp.csh WW3execcomp.csh
>
>ln -sf tools/envs.ncrc6.intel23 envs.ncrc6.intel23


> Gaea Instructions:
>
> cd FMS_Wave_Coupling
> 
> ./FMScomp.csh
> 
> ./WW3comp.csh
> 
> ./MOM6comp.csh
> 
> ./WW3execcomp.csh


If working on Gaea or the GFDL workstation, these steps should successfully compile libraries and executables needed to set-up and run the WW3 coupled system with FMS. You can check by run:
>cd FMS_Wave_Coupling
>
>ls build/ncrc6.intel23/wave_ice_ocean/REPRO/MOM6

### Running - OM4_025.JRA example

1. First follow the instructions to download the MOM6-examples input data (https://github.com/NOAA-GFDL/MOM6-examples/wiki/Getting-started#downloading-input-data).  Link this directory into the main directory for this repository as ".datasets", exactly as you would in MOM6-examples to use those test cases.  On gaea we simply execute "ln -sf <see location below> .datasets".  You would replace the source file location with the location you have put the datasets file you download.

On f6:  
>cd FMS_Wave_Coupling
>
>ln -sf /gpfs/f6/gfdl/world-shared/gold/datasets .datasets

On f5:  
>cd FMS_Wave_Coupling
>
>ln -sf /gpfs/f5/gfdl_o/world-shared/datasets .datasets

2. Change to the OM4_025.JRA test case directory

> cd examples/OM4_025.JRA

3. We next have to set-up the grid.

a. (Optional) If you are on a system that has access to the FMS/FRE tools, you can build your own grids and exchange grids (these tools are available on NOAA/GFDL github: FRE-NCtools).  See the GRID directory for some ideas of how these grids can be created to work with the wave model.  You would need to run the BuildExchangeGrid.csh first and WaveMosaics.py (cshell and python) scripts both to create all necesssary files (there are some pseudo-hacks needed to set-up the grid_spec.nc and the wave related exchange grids, if you are having trouble getting the wind into the wave model this grid_spec step is critical). The exchange grids can be generated at OM4_025.JRA/INPUT/EXCHANGE_GRIDS. To run BuildExchangeGrid.csh, you have to copy the BUildExchangeGrid.csh at FMS_Wave_Coupling/examples/Baltic_OM4_025/INPUT/ExchangeGrids and make some edits with the correct fre/bronx version. Also, You might not want to run this on a single login node, it is highly recommended to run this on parallel (using r.g. srun --ntasks=30 make_coupler_mosaic_parallel replacing make_coupler_mosaic). After running the BuildExchangeGrid.csh, you will obtain an updated file named with grid_spec_waves.nc. Replace the contents of the original grid_spec.nc file in the OM4_025.JRA/INPUT/ directory with the contents of grid_spec_waves.nc while keeping file name as grid_spec.nc. Alternatively, you can simply create a symbolic link in the OM4_025.JRA/INPUT/ directory using the following command: ln -s EXCHANGE_GRIDS/grid_spec_waves.nc grid_spec.nc. But, this is all optional, you can simply run with the example here to have a 0p25 degree resolution case on the MOM6 native 1/4 degree grid.  

b. You will need to update the WW3 grid files in WW3/PreProc, see WW3/PreProc/GenGrid.py for an example (this script should create the basic files for you without modification). This generates the WW3 Depth grid for a curvilinear tripolar grid on the MOM6 native 1/4 degree grid.  

> cd WW3/PreProc  
> python GenGrid.py

c. Next you need to create the mod_def.ww3 file for WW3's internal grid.  Navigate to WW3/PreProc and execute the ww3_grid (note on GFDL/Gaea you need to load the NetCDF libraries used to compile, e.g., on GFDL system: "module load netcdf/4.2" and on Gaea "module load cray-netcdf" before this will work):

> cd WW3/PreProc  
> ../../../../build/ncrc6.intel23/ww3_grid/REPRO/ww3_grid

Please replace "ncrc6.intel23" with your compiler environment.

2. Don't forget to create a RESTART directory within the OM4_025.JRA example directory:
>cd examples/OM4_025.JRA
>
> mkdir RESTART

4.  Now we should be ready to run.  To run on Gaea we can either submit a job through the batch system, or run the job interactively.  In this example we are going to run it interactively.

> Gaea Instructions:
>
> cd examples/OM4_025.JRA  
> salloc --clusters=c6 --qos=normal --nodes=10 --x11  
> srun -n 320 ../../build/ncrc6.intel23/wave_ice_ocean/REPRO/MOM6

5.  If this works, then congratulations, you have successful set-up, compiled, and run this example. If you succeded in running the exmaple but run into the errors at the MPI finalize, like below:
>forrtl: severe (174): SIGSEGV, segmentation fault occurred
>
>Image              PC                Routine            Line        Source
>         
>libpthread-2.31.s  00007F663D2DF910  Unknown               Unknown  Unknown
>
>libmlx5.so.1.24.4  00007F663AA4DC4B  Unknown               Unknown  Unknown
>
>libmlx5.so.1.24.4  00007F663AA9881A  Unknown               Unknown  Unknown
>
>libfabric.so.1.23  00007F663B0BEA73  Unknown               Unknown  Unknown
>
>libfabric.so.1.23  00007F663B0C7CF7  Unknown               Unknown  Unknown
>
>libfabric.so.1.23  00007F663B0D193C  Unknown               Unknown  Unknown
>
>libfabric.so.1.23  00007F663B0D23EB  Unknown               Unknown  Unknown
>
>libfabric.so.1.23  00007F663B0D4DD4  Unknown               Unknown  Unknown
>
>libmpi_intel.so.1  00007F663F895FFE  Unknown               Unknown  Unknown
>
>libmpi_intel.so.1  00007F663F6E9484  Unknown               Unknown  Unknown
>
>libmpi_intel.so.1  00007F663E174854  MPI_Finalize          Unknown  Unknown
>
>libmpifort_intel.  00007F664007D2B9  pmpi_finalize__       Unknown  Unknown

You need to add one line before you start running the MOM6 executable: 

>export FI_VERBS_PREFER_XRC=0
>
In C6 platform, if you encountered any problems with "fatal OVERFLOW buffer list exhausted", try to use the code in the directory of Examples/OM4_025.JRA before you run the case:

>export FI_CXI_RX_MATCH_MODE=hybrid

If the error stays, you might need to try to run with a different core number (e.g. try with srun -n 400 or 600). There is much more we can do with this including customizing set-ups, and processing and manipulating output.  Adding more instructions to this README.md is always welcome!

6. Basic instructions for creating WW3 output files:  MOM6 creates output in an easy to use netCDF format, but WW3 output is stored as binary files which need a further processing step to convert to netCDF.  You should have all the tools to do this already in place.  All you need to do is navigate to WW3/PostProc, and find the build/intel/wave_ice_ocean/ww3_ounf/ww3_ounf executable.  If you run it in this place, the proper files should already be linked to create netCDF from the mod_def and out_grd files.  Note that the ww3_ounf.inp can be edited (along with ww3_multi.inp) to specify diagnostics to save and frequency.  More information can be found in the WW3 directory.
