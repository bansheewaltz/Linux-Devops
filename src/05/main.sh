#!/bin/bash


if ! [[ $# == 1 ]]; then
  echo "Error: the script takes exactly one parameter"
  exit 1
fi

if ! [[ $1 =~ .*\/$ ]]; then
  echo "Error: the provided path does not end with '/'"
  exit 1
fi

if ! [[ -d $1 ]]; then
  echo "Error: the provided directory does not exist"
  exit 1
fi

time_elapsed(){
  LC_NUMERIC="en_US.UTF-8"
  echo "$2 - $1" | bc | xargs printf "%.1lf\n"
}

path="$1"


time_start=$(date +%s.%N)
echo "Total number of folders (including all nested ones) = $(sudo find "$path" -mindepth 1 -type d | wc -l)"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
      sudo du -hS "$path" | sort -hr | nl | awk '{printf "%d - %s, %sB\n", $1, $3, $2}' | head -5
echo "Total number of files = $(sudo find "$path" -mindepth 1 -type f | wc -l)"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $(sudo find "$path" -type f -name '*.conf' | wc -l)"
echo "Text files = $(sudo find "$path" -type f -exec file {} + | grep text | wc -l)"
echo "Executable files = $(sudo find "$path" -type f -executable | wc -l)"
echo "Log files (with the extension .log) = $(sudo find "$path" -type f -name '*.log' | wc -l)"
echo "Archive files = $(sudo find "$path" -type f -exec file {} + | grep -E "compressed|archive"| wc -l)"
echo "Symbolic links = $(sudo find -L "$path" -type f -exec file {} + | grep symbolic | wc -l)"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
      sudo find "$path" -type f -exec du -hS {} + | sort -hr | nl | head | awk '{printf "%d - %s, %sB\n", $1, $3, $2}'
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file) "
      sudo find "$path" -type f -executable -exec du -sh {} + | sort -hr | nl | head | awk '{cmd = "md5sum " $3; cmd|getline result; printf "%d - %s, %sB, %s\n", $1, $3, $2, result}' | awk '{print $1,$2,$3,$4,$5}'
time_end=$(date +%s.%N)

echo "Script execution time (in seconds) =" $(time_elapsed $time_start $time_end)
