





time_range="07/Sep/2023:20:48 07/Sep/2023:20:49"
re_timestamp='[0-9]{2}/[a-zA-z]{3}/[0-9]{4}:[0-9]{2}:[0-9]{2}'
time_start=$(echo time_range | cut -d " " -f1)
time_end=$(echo time_range | cut -d " " -f2)
if [[ ! $time_start =~ $re_timestamp || ! $time_end =~ $re_timestamp ]]; then 
  echo true
else
  echo false
fi
# time_start=07/Sep/2023:20:48
# re_time_format='[0-9]{2}/[a-zA-z]{3}/[0-9]{4}:[0-9]{2}:[0-9]{2}'
# if [[ $time_start =~ re_time_format ]]; then 
#   echo true
# else
#   echo false
# fi
