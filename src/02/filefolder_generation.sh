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

# generates folder names for which generates filenames of a specified size
### FOLDER NAME GENERATION
function generate_filefolder() {
  path=$1
  dir_count=$2
  file_count=$3
  for ((dname_len = min_dname_len, dcount = 0; ; dname_len++)); do
    declare -a dname_id
    # custom number system with base n of len k; + older "bit" as a stop flag
    for ((i = 0; i < dname_len-dir_alph_len+1; i++)); do 
      dname_id[i]=0; done
    while true; do
      if ! next_name dname_id dir_alph; then
        break; fi
      dname=$name
      fulldname="${path}/${dname}_${date}"
      if ! mkdir -p "$fulldname" 2> /dev/null; then
        return 0; fi
  ### FILE NAME GENERATION
      for ((bname_len = min_fname_len, fcount = 0; ; bname_len++)); do
        bname_id=()
        for ((j = 0; j < bname_len-bn_alph_len+1; j++)); do 
          bname_id[j]=0; done
        while true; do
          if ! next_name bname_id bn_alph; then
            break; fi
          bname=$name
  ### FILE EXTENSION GENERATION
          for ((ename_len = min_ext_len; ename_len <= bname_len; ename_len++)); do
            ename_id=()
            for ((j = 0; j < ename_len-ext_alph_len+1; j++)); do 
              ename_id[j]=0; done
            while true; do
              if ! next_name ename_id bn_alph; then
                break; fi
              ename=$name
  ### LOGGING
              file="${fulldname}/${bname}_${date}.${ename}"
              dd if=/dev/zero of="$file" bs="${file_size_mib}MiB" count=1 status=none
              # fallocate -l "${file_size_mib}KiB" "$file" # only reserves memory
              echo "$file $(date +'%d/%h/%Y:%H:%M:%S') ${file_size_mib}MiB" >> $logfile
  ### STOP CONDITIONS            
              ((fcount++))
              if is_memory_limit; then
                return 1; fi
              if ((fcount >= file_count)); then
                break 4; fi
            done
          done
        done
      done
      ((dcount++))
      if ((dcount >= dir_count)); then
        return 0; fi
    done
  done
}
