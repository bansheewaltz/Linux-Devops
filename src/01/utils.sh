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
  limit_B=$((MEMORY_LIMIT_GIB * 1024 * 1024 * 1024))
  if ((free_space_B <= limit_B)); then
  # if perl -e "exit ($free_space_B <= $limit_B? 0 : 1);"; then
    return 0
  else 
    return 1
  fi
}

function tidy_up_comb_number() {
  local -i n=$1
  local -i k=$2
  local -n comb_number=$3
  for ((i = k; i > 0; i--)); do
    # if number spilled over: xx0(n-1)xx
    if ((comb_number[i] > n-1)); then
      ((comb_number[i-1]++)) # set xx1(n-1)xx
      # each letter has to be in a restricted order
      for ((j = i; j <= k; j++)); do # set xx11..1
        comb_number[j]=${comb_number[j-1]}; done
    fi
  done
}

function assemble_name() {
  local -n name_id_ref=$1
  local -i name_id_len=${#name_id_ref[@]}
  local -n alphabet_ref=$2
  local -i alphabet_len=${#alphabet_ref[@]}
  # each character has to occur at least once
  local -a letter_counts
  for ((i = 0; i < alphabet_len; i++)); do
    letter_counts[i]=1; done
  # read letter counts from name_id
  for ((i = 1; i < name_id_len; i++)); do
    ((letter_counts[name_id[i]]++)); done
  # assemble name from letter counts according to alphabet
  local name
  for ((i = 0; i < alphabet_len; i++)); do
    for ((j = 0; j < letter_counts[i]; j++)); do
      name+=${alphabet[i]}; done
  done
  
  echo "$name"
}

# idea: create combinations with repetitions in a lexicographical order
# taking into account that each character has to occur at least once
function next_name() {
  local -n name_id=$1
  local -n alphabet=$2
  # custom number system with base n of len k; + older "bit" as a stop flag
  # n things taken k at a time WITH repetition, name_id is a combination key
  local n=${#alphabet[@]}
  local k=$((${#name_id[@]} - 1))
  # if there is a carry condition
  tidy_up_comb_number $n $k name_id
  # name exhaustion condition check
  if ((name_id[0] > 0)); then
    return 1
  fi
  # taking into account that each character has to occur at least once
  name=$(assemble_name name_id alphabet)
  # initialization of the next combination
  ((name_id[k] += 1))  # xxxN -> xxxN+1
}
