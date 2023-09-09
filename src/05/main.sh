#!/bin/bash
source parameter_validation.sh

arg_count=$#
parameter=$1

validate_parameter


logs=$(cat ../04/logs/*.log)

if [ "$parameter" -eq 1 ]; then
  echo "$logs" | sort -nk 9
fi

if [ "$parameter" -eq 2 ]; then
  echo "$logs" | awk '{print $1}' | sort -u
fi

if [ "$parameter" -eq 3 ]; then
  echo "$logs" | awk '{
    if (match($9, /^[4,5]/) != 0) {
      print $0
    }
  }'
fi

if [ "$parameter" -eq 4 ]; then
  echo "$logs" | awk '{
    if (match($9, /^[4,5]/) != 0) {
      print $1
    }
  }' | sort -u
fi
