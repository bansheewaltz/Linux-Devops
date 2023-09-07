#!/bin/bash
source input_validation.sh
source filefolder_generation.sh
source utils.sh

declare -x arg_count=$#
declare -x dir_letters=$1
declare -x file_letters=$2
declare -x bn_letters=${file_letters%.*}
declare -x ext_letters=${file_letters#*.}
declare -x file_size_mib=$3


validate_input
SECONDS=0  # to time script execution

### SCRIPT PARAMETERS ###
memory_limit_gib=1
min_dname_len=4
min_fname_len=4
min_ext_len=2
dir_count_min=1
dir_count_max=10
file_count_min=1
file_count_max=5
logfile="logfile.$(date +'%Y-%m-%d').log"
### ----------------- ###

### CONSTANTS ###
# directory name
dir_alph=($(echo $dir_letters | grep -o .))
dir_alph_len=${#dir_letters}
# file basename
bn_alph=($(echo $bn_letters | grep -o .))
bn_alph_len=${#bn_letters}
# file extension
ext_alph=($(echo $ext_letters | grep -o .))
ext_alph_len=${#ext_letters}

# set minimum lengths based on alphabet and restrictions
if ((min_dname_len < dir_alph_len)); then
  min_dname_len=dir_alph_len; fi
if ((min_fname_len < bn_alph_len)); then
  min_fname_len=bn_alph_len; fi
if ((min_ext_len < ext_alph_len)); then
  min_ext_len=ext_alph_len; fi

printf -v date '%(%d%m%y)T'
### --------- ###


paths=($(find / -type d))
while [ ${#paths[@]} -ne 0 ] ; do
    rand=$((RANDOM % ${#paths[@]}))
    path=${paths[rand]}
    arr_remove_element paths $path

    if [ -L "${path%/}" ]; then  # symbolic link check
      continue; fi
    if [[ ! -w $path ]]; then   # writability check
      continue; fi
    if [[ $path =~ (bin|sbin) ]]; then  # forbidden dirs check
      continue; fi
    if (( RANDOM % 2 == 0 )); then  # random skip condition
      continue; fi
    
    dir_count=$(rand_int_in_range $dir_count_min $dir_count_max)    
    if ! generate_filefolder $path $dir_count; then
      break; fi
done

echo "Script execution time: $(($SECONDS/3600))h:$((($SECONDS/60)%60))m:$(($SECONDS%60))s"
