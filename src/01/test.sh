#!/bin/bash

test_entries="test_entries.txt"
IFS=$'\n'


counter=1
for entry in $(cat $test_entries)
do
  IFS=" "
  entry=($entry)
  
  printf "%2d. test entry: $entry\n" "$counter"
  echo -n "    result: "
  bash main.sh "${entry[@]}"
  echo

  ((counter++))
done
