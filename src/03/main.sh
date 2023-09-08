#!/bin/bash
source parameter_validation.sh
source utils.sh

arg_count=$#
method=$1

reg_method="^[1-3]$"
reg_dir="^/"
reg_num="^[0-9]+$"
reg_sym1="^[a-zA-Z]{1,7}$"
reg_sym2="([a-zA-Z])(.*?\1)"
reg_sym_file="^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$"
reg_size_file="^[1-9][0-9]?Mb$|^100Mb$"

reg_date="^[0-3][0-9] [a-zA-Z]{3} [0-9]{4} [0-2]?[0-9]:[0-5][0-9]$"
reg_mask="^[a-zA-Z]{1,7}_[0-9]{6}$"


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
    echo "The file is not found. Try again. Or write \"exit\"."
    read -r logfile
    if [ "$logfile" = exit ]; then
      exit 0; fi
  done

  space_before=$(get_free_space_B)
  awk '{print $1}' $logfile | xargs rm 2>/dev/null
  space_after=$(get_free_space_B)
  space_cleaned=$((space_after - space_before))
  echo
  echo $(cat $logfile | wc -l) files removed, \
       $(format_bytes_output $space_cleaned) of memory freed
  rm $logfile
fi

# Cleanup by timestamp
if [ "$method" -eq 2 ]; then
  re_timestamp='^[0-9]{2}/[A-Z]{1}[a-z]{2}/[0-9]{4}:[0-9]{2}:[0-9]{2}$'
  echo "Input the date and time range of creation up to the minute"
  echo "Example: 07/Sep/2023:20:48 07/Sep/2023:20:49"
  echo
  
  read -r time_range
  time_start=$(echo "$time_range" | cut -d " " -f1)
  time_end=$(echo "$time_range" | cut -d " " -f2)
  while [[ ! $time_start =~ $re_timestamp || ! $time_end =~ $re_timestamp ]]; do
    echo "Wrong format. Try again. Or write \"exit\"."
    read -r time_range
    if [ "$time_range" = exit ]; then
      exit 0; fi
    time_start=$(echo "$time_range" | cut -d " " -f1)
    time_end=$(echo "$time_range" | cut -d " " -f2)
  done
fi

# Cleanup by timestamp
if [ "$method" -eq 3 ]; then
  re_timestamp='^[0-9]{2}/[A-Z]{1}[a-z]{2}/[0-9]{4}:[0-9]{2}:[0-9]{2}$'
  echo "Input the date and time range of creation up to the minute"
  echo "Example: 07/Sep/2023:20:48 07/Sep/2023:20:49"
  echo
  read -r time_range
  time_start=$(echo "$time_range" | cut -d " " -f1)
  time_end=$(echo "$time_range" | cut -d " " -f2)
  while [[ ! $time_start =~ $re_timestamp || ! $time_end =~ $re_timestamp ]]; do
    echo "Wrong format. Try again. Or write \"exit\"."
    read -r time_range
    if [ "$time_range" = exit ]; then
      exit 0; fi
    time_start=$(echo "$time_range" | cut -d " " -f1)
    time_end=$(echo "$time_range" | cut -d " " -f2)
  done
fi

# if [[ $method == 1 ]]; then
#   log_file=$2
#   if [[ ! -f ${log_file} ]]; then
#     echo "Error: The log file not found"
#   else
#     ./del_by_log.sh ${log_file}
#   fi
# elif [[ $method == 2 ]]; then
#   start=$2
#   end=$3
#   if [[ ! "$start" =~ $reg_date  || ! "$end" =~ $reg_date ]]; then
#     echo 'Error in the 2st or 3th argument. Example for any: "10 aug 2023 15:30"'
#   else
#     ./del_by_date.sh "$start" "$end"
#   fi
# elif [[ $method == 3 ]]; then
#   mask=$2
#   if [[ ! "$mask" =~ $reg_mask ]]; then
#     echo "Error in the 2st argument. Example: asdqwer_110823"
#   else
#     ./del_by_mask.sh "$mask"
#   fi
# else 
#   echo "Error: The 1st argument must be from 1 to 3"
# fi
