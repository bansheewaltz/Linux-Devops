#!/bin/bash

gen_ip () {
  local remote_addr="100.67.224.35"
  local n1=$((1 + RANDOM % 127))
  local n2=$((1 + RANDOM % 255))
  local n3=$((1 + RANDOM % 255))
  local n4=$((1 + RANDOM % 255))
  n=$((1 + RANDOM % 8))
  case $n in
    1) remote_addr="${n1}.${n2}.${n3}.${n4}";;
    2) remote_addr="101.67.224.35";;
    3) remote_addr="41.27.144.140";;
    4) remote_addr="27.17.225.75";;
    5) remote_addr="111.87.21.39";;
    6) remote_addr="42.69.214.15";;
    7) remote_addr="104.201.24.55";;
    8) remote_addr="85.73.227.39";;
  esac
  echo $remote_addr
}
