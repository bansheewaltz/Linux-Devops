#!/bin/bash

# shellcheck source=utils.sh
source utils.sh
# shellcheck source=input_validation.sh
source input_validation.sh
# shellcheck source=file_folder_generation.sh
source filefolder_generation.sh

declare -x arg_count=$#
declare -x dir_letters=$1
declare -x file_letters=$2
declare -x bn_letters=${file_letters%.*}
declare -x ext_letters=${file_letters#*.}
declare -x file_size_mib=$3

validate_input

memory_limit_gib=1
min_dname_len=4
min_fname_len=4
min_ext_len=2
dir_count_min=1
dir_count_max=10
file_count_min=1
file_count_max=5

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
logfile="logfile.$(date +'%Y-%m-%d').log"

for path in $(find / -type d) ; do
    if [ -L "${path%/}" ]; then  # symbolic link check
      continue; fi
    if [[ ! -w $path ]]; then   # writability check
      continue; fi
    if [[ $path =~ (bin|sbin) ]]; then  # forbidden dirs check
      continue; fi
    if (( RANDOM % 2 == 0)); then  # random skip condition
      continue; fi
    
    dir_count=$(rand_int_in_range $dir_count_min $dir_count_max)
    file_count=$(rand_int_in_range $file_count_min $file_count_max)
    
    if ! generate_filefolder $path $dir_count $file_count; then
      break; fi
done
