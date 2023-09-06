#!/bin/bash
source utils.sh
source input_validation.sh

declare -x arg_count=$#
declare -x path=$1
declare -x dir_count=$2
declare -x dir_letters=$3
declare -x file_count=$4
declare -x file_letters=$5
declare -x file_size_kib=$6

validate_input

MEMORY_LIMIT_GIB=1
MIN_DNAME_LEN=4
MIN_FNAME_LEN=4
MIN_EXT_LEN=2

# directory name
dir_alph=($(echo $dir_letters | grep -o .))
dir_alph_len=${#dir_letters}
# file basename
bn_letters=${file_letters%.*}
bn_alph=($(echo $bn_letters | grep -o .))
bn_alph_len=${#bn_letters}
# file extension
ext_letters=${file_letters#*.}
ext_alph=($(echo $ext_letters | grep -o .))
ext_alph_len=${#ext_letters}

# set minimum lengths based on alphabet and restrictions
if ((MIN_DNAME_LEN < dir_alph_len)); then
  MIN_DNAME_LEN=dir_alph_len; fi
if ((MIN_FNAME_LEN < bn_alph_len)); then
  MIN_FNAME_LEN=bn_alph_len; fi
if ((MIN_EXT_LEN < ext_alph_len)); then
  MIN_EXT_LEN=ext_alph_len; fi

printf -v date '%(%d%m%y)T'
logfile="logfile.$(date +'%Y-%m-%d').log"

# generates folder names for which generates filenames of a specified size
### FOLDER NAME GENERATION
for ((dname_len = MIN_DNAME_LEN, dcount = 0; ; dname_len++)); do
  declare -a dname_id
  # custom number system with base n of len k; + older "bit" as a stop flag
  for ((i = 0; i < dname_len-dir_alph_len+1; i++)); do 
    dname_id[i]=0; done
  while true; do
    if ! next_name dname_id dir_alph; then
      break; fi
    dname=$name
    fulldname="${path}/${dname}_${date}"
    mkdir -p "$fulldname"
### FILE NAME GENERATION
    for ((bname_len = MIN_FNAME_LEN, fcount = 0; ; bname_len++)); do
      bname_id=()
      for ((j = 0; j < bname_len-bn_alph_len+1; j++)); do 
        bname_id[j]=0; done
      while true; do
        if ! next_name bname_id bn_alph; then
          break; fi
        bname=$name
### FILE EXTENSION GENERATION
        for ((ename_len = MIN_EXT_LEN; ename_len <= bname_len; ename_len++)); do
          ename_id=()
          for ((j = 0; j < ename_len-ext_alph_len+1; j++)); do 
            ename_id[j]=0; done
          while true; do
            if ! next_name ename_id bn_alph; then
              break; fi
            ename=$name
### LOGGING
            file="${fulldname}/${bname}_${date}.${ename}"
            dd if=/dev/zero of="$file" bs="${file_size_kib}KiB" count=1 status=none
            # fallocate -l "${file_size_kib}KiB" "$file" # only reserves memory
            echo "$file $(date +'%d/%h/%Y:%H:%M:%S') ${file_size_kib}KiB" >> $logfile
### STOP CONDITIONS            
            ((fcount++))
            if is_memory_limit; then
              break 6; fi
            if ((fcount >= file_count)); then
              break 4; fi
          done
        done
      done
    done
    ((dcount++))
    if ((dcount >= dir_count)); then
      break 2; fi
  done
done
