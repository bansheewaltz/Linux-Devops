#!/bin/bash

function gen_date {
  min_year=2004
  max_year=2022
  
  year=$((min_year + RANDOM % (max_year - min_year)))
  month=$((1 + RANDOM % 12))
  hour=$((1 + RANDOM % 6))
  minute=$((RANDOM % 60))
  sec=$((RANDOM % 60))
  
  day=$((1 + RANDOM % 31))
  if (( month == 2 && day > 28 )); then
    day=28; fi
  if (( day == 31 && (month == 4 || month == 6 || month == 9 || month == 11) )); then
    day=30;fi
  
  month_numeric=$month
  case $month in
     1) month="Jan";;
     2) month="Feb";;
     3) month="Mar";;
     4) month="Apr";;
     5) month="May";;
     6) month="Jun";;
     7) month="Jul";;
     8) month="Aug";;
     9) month="Sep";;
    10) month="Oct";;
    11) month="Nov";;
    12) month="Dec";;
  esac
}
