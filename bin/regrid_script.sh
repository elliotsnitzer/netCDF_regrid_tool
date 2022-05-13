#!/bin/sh

#load cdo module for regridding
module load cdo/1.7.1

#retrieve job number and task number
IFS='_' read -ra job_info <<< $SLURM_JOB_NAME
job_num="${job_info[1]}"
task_num="${job_info[2]}"
exe_num="01"
#for task 1 only, run directory mapping script
if [[ "$task_num" == *"$exe_num"* ]]; then 
    bash cron_script.sh
fi

#params variable set equal to list of parameters recieved by script
params=$@
#split params string based on spaces
IFS=' ' read -ra array <<< $params
#create variables for each parameter
ice_sheet="${array[0]}"
model_grp="${array[1]}"
is_model="${array[2]}"
exp="${array[3]}"
ingrid="${array[4]}"
outgrid="${array[5]}"
file_name="${array[6]}"
num_files="${array[7]}"
now="$(date +'%m-%d-%Y')"

#set initial pathways for input files, output files, and gridding files
inpath="/projects/grid/ghub/ISMIP6/Projections"
outpath="/gpfs/scratch/ghub/regrid-tool"
gdfs="/projects/grid/ghub/ISMIP6/Grids"

#set inpath based on ice sheet parameter
if [ $ice_sheet == "GIS" ]; then
    inpath="${inpath}/GrIS/output"
    gdfs="${gdfs}/GrIS/GDFs"
    ice_sheet="GrIS"
else
    inpath="${inpath}/AIS/output"
    gdfs="${gdfs}/AIS/GDFs"
    ice_sheet="AIS"
fi

#set ingrid file and adjust ingrid size format to fit file name
inval=''
ingdf=''
if [ ${#ingrid} -eq 3 ]; then
    inval="0${ingrid:0:1}"
    ingdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${inval}000m.nc"
elif [ ${#ingrid} -eq 4 ]; then
    inval=${ingrid:0:2}
    ingdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${inval}000m.nc"
elif [ ${#ingrid} -eq 5 ]; then
    inval="00${ingrid:2:1}"
    ingdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${inval}00m.nc"
fi

#set outgrid file and adjust outgrid size format to fit file name
outval=''
outgdf=''
if [ ${#outgrid} -eq 3 ]; then
    outval="0${outgrid:0:1}"
    outgdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${outval}000m.nc"
elif [ ${#outgrid} -eq 4 ]; then
    outval=${outgrid:0:2}
    outgdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${outval}000m.nc"
elif [ ${#outgrid} -eq 5 ]; then
    outval="00${outgrid:2:1}"
    outgdf="${gdfs}/grid_ISMIP6_${ice_sheet}_${outval}00m.nc"
fi

#set final infile path to specific file name
infile="${inpath}/${model_grp}/${is_model}/${exp}/${file_name}"
#set outdir path
outdir="${outpath}/${now}_job${job_num}_${ingrid}to${outgrid}"
echo $outdir
#if outdir doesn't exist, create it in scratch
if [ ! -d $outdir ]; then
    mkdir $outdir
fi
#set outfile path using netCDF file naming convention
outfile="${outdir}/${file_name}"
#execute regridding operation
cdo remapycon,${outgdf} -setmisstoc,0 -setgrid,${ingdf} ${infile} ${outfile}