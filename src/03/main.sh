#!/bin/bash
source parameter_validation.sh
source utils.sh

arg_count=$#
method=$1


validate_parameter

# Cleanup by log file
if [ "$method" -eq 1 ]; then
  echo "Input the log file path and its name"
  example=$(find ../02 -name "*.log")
  if [ -z "$example" ]; then
    example="../02/logfile.2023-09-07.log"; fi
  echo "Example: $example"
  echo
  
  read -r logfile
  while [ ! -f "$logfile" ]; do
    echo "The file is not found. Try again. Or write \"exit\" to exit the script."
    read -r logfile
    if [ "$logfile" = exit ]; then
      exit 0; fi
  done

  files=$(awk '{print $1}' "$logfile")
  cleanup "$files"
  rm $logfile
fi

# Cleanup by timestamp
if [ "$method" -eq 2 ]; then
  echo "Input the date and time range of creation up to the minute"
  echo "Example: 07/Sep/2023:20:48 07/Sep/2023:20:49"
  echo
  
  read -r time_range
  time_start=$(echo "$time_range" | cut -d " " -f1)
  time_end=$(echo "$time_range" | cut -d " " -f2)
  re_timestamp='^[0-9]{2}/[A-Z]{1}[a-z]{2}/[0-9]{4}:[0-9]{2}:[0-9]{2}$'
  while [[ ! $time_start =~ $re_timestamp || ! $time_end =~ $re_timestamp ]]; do
    echo "Wrong format. Try again. Or write \"exit\" to exit the script."
    read -r time_range
    if [ "$time_range" = exit ]; then
      exit 0; fi
    time_start=$(echo "$time_range" | cut -d " " -f1)
    time_end=$(echo "$time_range" | cut -d " " -f2)
  done
  
  fmt_start=$(echo $time_start | sed 's/\//-/g' | sed 's/:/ /1')
  fmt_end=$(echo $time_end | sed 's/\//-/g' | sed 's/:/ /1')
  files=$(find / -type f \
                 -not -size -1M \
                 -newermt "$fmt_start" \
                 -not -newermt "$fmt_end" \
                  2>/dev/null)
  cleanup "$files"
  echo "you can check the list of deleted files at report.txt"
  echo "$files" > report.txt
fi

# Cleanup by timestamp
function read_mask {
  read -r name_mask
  re_name_general='^[a-zA-Z]{1,7}_[0-9]{6}$'
  re_repeated_chars='([a-zA-Z]).*?\1'
  while [[ ! $name_mask =~ $re_name_general || ${name_mask%%_*} =~ $re_repeated_chars ]]; do
    echo "Wrong format. Try again. Or write \"exit\" to exit the script."
    read -r name_mask
    if [ "$name_mask" = exit ]; then
      exit 0; fi
  done
}

function find_files_by_mask() {
  name_mask=$1
  letters=${name_mask%%_*}
  date=${name_mask##*_}
  re_letters=
  for (( i=0; i<${#letters}; i++ )); do
    re_letters+=${letters:$i:1}+; done
  mask_re=".*/${re_letters}_${date}"
  filefolders=$(find / -type d -regex "$mask_re")
  if [ "$filefolders" ]; then
    files=$(find $filefolders -type f);
  else
    files=
  fi
  echo "$files"
}

if [ "$method" -eq 3 ]; then
  echo "Input the filefolder name mask (i.e. characters, underlining and date)"
  printf -v date_suffix '%(%d%m%y)T'
  echo "Example: ab_${date_suffix}"
  echo
  
  lines_to_remove=0
  while true; do
    read_mask
    files=$(find_files_by_mask "$name_mask")
    files_n=$(echo "$files" | wc -l)
    echo
    echo "files found:"
    echo "$files"
    echo
    lines_to_remove=5
    while true; do
      read -p "Do you wish to remove the above files?[Y/n] " yn
      case $yn in
          [Yy]* ) cleanup "$files" ; exit 0;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no."; ((lines_to_remove+=2));;
      esac
    done
    printf "\033[%sA" $(($lines_to_remove + $files_n))
    printf "\033[J"
  done
fi
