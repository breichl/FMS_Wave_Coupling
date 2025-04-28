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

1.  First compile the FMS libraries using the provided script:
> ./tools/FMScomp.csh  

2.  Next compile the WW3 libraries and extra executables using the provided scripts:
> ./tools/WW3libcomp.csh  
> ./tools/WW3execcomp.csh  

3.  Finally, compile the coupled model:
> ./tools/MOM6comp.csh

If working on Gaea, these steps should successfully compile libraries and executables needed to set-up and run the WW3 coupled system with FMS. You can check for the final executable at:
> cd FMS_Wave_Coupling  
> ls build/ncrc6.intel23/wave_ice_ocean/REPRO/MOM6

### Compiling on another system

The steps to compile on another system are primarily to identify and update your compiler and netCDF/MPI library information.  For Gaea, we store the necessary modules to load in the environment file.  Since we use the mkmf build system we also use a mkmf template (ncrc-intel.mk) that is configured for our system.  The modules, libraries, and mkmf templates would need to be updated to be consistent with your system compilers and libraries.

### Running examples

1. First follow the instructions to download the MOM6-examples input data (https://github.com/NOAA-GFDL/MOM6-examples/wiki/Getting-started#downloading-input-data).  Link this directory into the main directory for this repository as ".datasets", exactly as you would in MOM6-examples to use those test cases.  On gaea we simply execute "ln -sf <see location below> .datasets".  You would replace the source file location with the location you have put the datasets file you download.

On f6:  
>cd FMS_Wave_Coupling
>
>ln -sf /gpfs/f6/gfdl/world-shared/gold/datasets .datasets

On f5:  
>cd FMS_Wave_Coupling
>
>ln -sf /gpfs/f5/gfdl_o/world-shared/datasets .datasets

You should now be ready to run examples.  Check out the examples directory for working test cases and follow the instructions within the test case to run!