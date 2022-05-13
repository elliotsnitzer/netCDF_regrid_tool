#!/bin/sh
#output directory and main directory depend on prearranged tool infrastructure
output_dir="/gpfs/scratch/esnitzer/option_files"
main_dir="/projects/grid/ghub/ISMIP6/Projections"
ice_sheet_dirs=("${main_dir}/GrIS/output" "${main_dir}/AIS/output")
#comment something
for d in ${!ice_sheet_dirs[@]};
do
    is_dir="${ice_sheet_dirs[$d]}"
    echo $is_dir
    grps=($(ls $is_dir))
    for g in ${!grps[@]};
    do
        echo "${grps[$g]}"
    done
    #ls "${d}" > "${output_dir}/ls_opts.txt"
    for g in ${!grps[@]};
    do
        grp_name="${grps[$g]}"
        grp_dir="${is_dir}/${grp_name}"
        if [ ! -d "$grp_dir" ]
        then
            continue
        fi
        echo $grp_dir
        is_mods=($(ls $grp_dir))
        for m in ${!is_mods[@]};
        do 
            echo "${is_mods[$m]}"
        done
        #comment something
        for m in ${!is_mods[@]};
        do
            mod_name="${is_mods[$m]}"
            mod_dir="${grp_dir}/${mod_name}"
            if [ ! -d "$mod_dir" ]
            then
                continue
            fi
            echo $mod_dir
            exps=($(ls $mod_dir))
            for e in ${!exps[@]};
            do
                echo "${exps[$e]}"
            done
            #commment something
            for e in ${!exps[@]};
            do
                exp_name="${exps[$e]}"
                exp_dir="${mod_dir}/${exp_name}*"
                echo $exp_dir
                files=($(ls $exp_dir))
                #comment something
                for f in ${!files[@]};
                do
                    file_name="${files[$f]}"
                    echo $file_name
                done
            done
        done
    done
done
