function is_in_docker {
  if [ -f /.dockerenv ]; then
      return 0
  else
      return 1
  fi
}

function get_free_space_B {
  if is_in_docker; then
    memory_max=$(cat /sys/fs/cgroup/memory.max)
    memory_cur=$(cat /sys/fs/cgroup/memory.current)
    # memory_free=$(awk -v a="$memory_max" -v b="$memory_cur" 'BEGIN { print (a - b)/1024 }') #kib
    memory_free=$((memory_max - memory_cur))
    echo $memory_free
  else 
    echo $(df -k / | awk '{ kib=$4; if (NR==2) print kib * 1024; }')
  fi
}

function is_memory_limit {
  free_space_B=$(get_free_space_B)
  limit_B=$((memory_limit_gib * 1024 * 1024 * 1024))
  if ((free_space_B <= limit_B)); then
  # if perl -e "exit ($free_space_B <= $limit_B? 0 : 1);"; then
    return 0
  else 
    return 1
  fi
}

function rand_int_in_range() {
  min=$1
  max=$2
  echo $(($RANDOM % ($max + 1 - $min) + $min))
}

function arr_remove_element() {
  local -n arr_ref=$1
  local element=$2
  
  local new_arr=()
  
  for value in "${arr_ref[@]}"; do
    if [[ $value != $element ]]; then
      new_arr+=($value); fi
  done
  
  arr_ref=("${new_arr[@]}")
}
