#!/bin/bash
source parameter_validation.sh

arg_count=$#
parameter=$1
logs=$(cat ../04/logs/*.log 2>/dev/null)

validate_parameter


if [ "$parameter" -eq 1 ]; then
  echo "$logs" | sort --numeric-sort --key=9
fi

if [ "$parameter" -eq 2 ]; then
  echo "$logs" | awk '{ print $1 }' | sort --unique
fi

if [ "$parameter" -eq 3 ]; then
  echo "$logs" | awk '{ if (match($9, /^[4,5]/)) print $0 }'
fi

if [ "$parameter" -eq 4 ]; then
  echo "$logs" | awk '{ if (match($9, /^[4,5]/)) print $0 }' | sort --unique
fi
