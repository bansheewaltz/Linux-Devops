#!/bin/bash

logs=$(cat ../04/logs/*.log 2>/dev/null)

if [ "$1" = terminal ]; then
  goaccess -a ../04/logs/*.log --log-format=COMBINED; fi

### static HTML output
# goaccess -a ../04/logs/*.log -o report.html --log-format=COMBINED

### Real-Time HTML Output at localhost:8082/report.html
report_dir="/var/www/html"
if [ "$1" = web ]; then
  service nginx start
  echo "$logs" | sort --numeric-sort --key=9 | goaccess -a -o $report_dir/1.html --log-format=COMBINED
  echo "$logs" | awk '!seen[$1] {print; ++seen[$1]}' | goaccess -a -o $report_dir/2.html --log-format=COMBINED
  echo "$logs" | awk '{ if (match($9, /^[4,5]/)) print $0 }' | goaccess -a -o $report_dir/3.html --log-format=COMBINED
  echo "$logs" | awk '{ if ( (match($9, /^[4,5]/)) && (!seen[$1]) ) print; ++seen[$1] }' | goaccess -a -o $report_dir/4.html --log-format=COMBINED
  goaccess -a ../04/logs/*.log -o $report_dir/report.html --log-format=COMBINED --real-time-html
fi
