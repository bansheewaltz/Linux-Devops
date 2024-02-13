#!/bin/bash

scrape_sysinfo(){
  echo "HOSTNAME = $(hostname)"
  echo "TIMEZONE = $(date +"$(cat /etc/timezone) UTC %Z")"
  echo "USER = $(whoami)"
  echo "OS = $(hostnamectl | grep 'Operating System' | cut -d' ' -f 3-)"
  echo "DATE = $(date +'%d %B %Y %R:%S')"
  echo "UPTIME = $(uptime --pretty | cut -d' ' -f 2-)"
  echo "UPTIME_SEC = $(awk '{printf $1}' /proc/uptime)"
  echo "IP = $(ip -4 a | grep inet | grep -v 'host' | awk '{print $2}' | head -1)"
  echo "MASK = $(ifconfig -a | grep netmask -m 1 | awk '{print($4)}')"
  echo "GATEWAY = $(ip route | awk '{print $3; exit}')"
  echo "RAM_TOTAL = $(free --mega | grep -e 'Mem' | awk '{printf "%.3f GB", $2/1024}')"
  echo "RAM_USED = $(free --mega | grep -e 'Mem' | awk '{printf "%.3f GB", $3/1024}')"
  echo "RAM_FREE = $(free --mega | grep -e 'Mem' | awk '{printf "%.3f GB", $4/1024}')"
  echo "SPACE_ROOT = $(df -BK | awk '/\/$/ {print $2}' | awk '{printf "%.2f MB", $1/1024}')"
  echo "SPACE_ROOT_USED = $(df -BK | awk '/\/$/ {print $3}' | awk '{printf "%.2f MB", $1/1024}')"
  echo "SPACE_ROOT_FREE = $(df -BK | awk '/\/$/ {print $4}' | awk '{printf "%.2f MB", $1/1024}')"
}
