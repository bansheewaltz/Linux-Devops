#!/bin/bash
source ./gen_agent.sh
source ./gen_bytes.sh
source ./gen_date.sh
source ./gen_ip.sh
source ./gen_request.sh
source ./gen_status.sh


next_time () {
  c_sec=$((5 + RANDOM % 50))
  ((sec += c_sec))
  while ((sec > 59)); do
    ((sec -= 60))
    ((++minute))
    if ((minute > 59)); then
      ((minute -= 60))
      ((++hour))
    fi
  done
  # echo "[$day/$month/$year:$hour:$minute:$sec]"
  # printf "[%.2d/%s/%d:%.2d:%.2d:%.2d +0700]" $day $month $year $hour $minute $sec
}

logfile_count=5
mkdir -p logs
for ((i = 0; i < logfile_count; i++)); do
  gen_date
  log_file=$(printf "logs/%.2d-%.2d-%d.log" $day $month $year)
  record_count=$((100 + RANDOM % 900))
  for ((j = 0; j < record_count; j++)); do
    next_time
    time_local=$(printf "[%.2d/%s/%d:%.2d:%.2d:%.2d +0700]" $day $month $year $hour $minute $sec)
    remote_addr=$(gen_ip)
    request=$(gen_request)
    body_bytes_sent=$(gen_bytes)
    status=$(gen_status)
    http_user_agent=$(gen_agent)
    record="${remote_addr} - - ${time_local} ${request} ${status} ${body_bytes_sent} \"-\" \"${http_user_agent}\""
    echo "$record" >> $log_file
  done
done
