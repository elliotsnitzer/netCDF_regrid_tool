#!/bin/sh
params=$@
IFS=' ' read -ra array <<< $params
job_num="${array[0]}"
out_dir="${array[1]}"
num_files="${array[2]}"
tar_archive="${out_dir}/${job_num}_archive.tar.gz"
find $out_dir -name "*.nc" | tar zcvf $tar_archive -T -
tar_size=$(ls -l $out_dir)
IFS=' ' read -ra array <<< $tar_size
tar_size="${array[6]}"
echo $tar_size
if [ $tar_size -lt 500000000 ]; then
    echo $tar_size
    tar_name="${job_num}_archive.tar.gz"
    find $out_dir -name "*.nc" | tar zcvf $tar_name -T -
fi