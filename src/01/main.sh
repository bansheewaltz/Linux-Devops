#!/bin/bash
source input_validation.sh

declare -x arg_count=$#
declare -x path=$1
declare -x subdir_count=$2
declare -x dir_letters=$3
declare -x file_count=$4
declare -x file_letters=$5
declare -x file_size=$6

validate_input
