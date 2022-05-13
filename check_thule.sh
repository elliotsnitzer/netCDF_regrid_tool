#!/bin/sh

thule_path="/gpfs/scratch/ghub/regrid-tool/thule-regrid-targets"
user_dirs=($(ls $thule_path))
echo $thule_path
for d in ${!user_dirs[@]};
do
    echo "${user_dirs[$d]}"
done
for d in ${!user_dirs[@]};
do
    dir_name="${user_dirs[$d]}"
    dir_path="${thule_path}/${dir_name}"
    echo $dir_path
    files=($(ls ${dir_path}))
    for f in ${!files[@]};
    do
        echo "${files[$f]}"
    done
done