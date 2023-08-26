function echoerr { 
  >&2 echo $@
}

function terminate {
  echoerr "Error: incorrect input"
  echoerr $1
  exit 1
}

regex_abs_path='^/[a-zA-Z0-9/_-]*[^/]$'
regex_root='^/$'
regex_dir='^[A-Za-z]{1,7}$'
regex_file='^[A-Za-z]{1,7}\.{1,1}[A-Za-z]{1,3}$'
regex_dir_count='^[1-9]+$'
regex_file_count='^[0-9]+$'
regex_file_size='^[0-9]+kb|Kb|KB|kB$'
num_size=$(echo $6 | sed 's/'[kK][bB]'//')

function validate_input {
  if [ $arg_count -ne 6 ]; then
    terminate "Run the script using 6 parameters"
  fi
  # first argument
  if ! [[ $path =~ $regex_abs_path || $path =~ $regex_root ]]; then
    terminate "The first parameter, the path, must be an absolute path to a \
               directory, without \"/\" in the end"
  fi

  if [[ ! -d $path ]]; then
    terminate "No such directory '$path'"
  fi

  if [[ ! -w $path ]]; then
    terminate "Permission denied for '$path'"
  fi
  # second argument
  if ! [[ $dir_count =~ $regex_dir_count ]]; then
    terminate "The Second parameter, the folder count, accepts only numbers \
               and value should be at least 1"
  fi

  if ! [[ $dir_letters =~ $regex_dir ]]; then
    terminate "The third parameter, the folder's name, must contain no more \
               than 7 characters of [A-Z], [a-z] without repetition"
  fi
  # fourth argument
  if ! [[ $4 =~ $regex_file_count ]]; then
    terminate "Incorrect input in the fourth parameter! Use only numbers."
  fi
  # fifth argument
  if ! [[ $5 =~ $regex_file ]]; then
    echo "Incorrect input in the fifth parameter!"
    terminate "A file\`s name must contain only A-z, a-z letters and you can \
               use not more 7 letters for a name and not more 3 letters for \
               an extension. Letters in a name and in an extension can\`t \
               repeat. Example: sdf.ex"
  fi
  # sixth argument
  if ! [[ $6 =~ $regex_file_size ]]; then
    terminate "Input error in the sixth parameter! Please, write size of \
               files in kb. Example: 123kb."
  fi

  if [ $num_size -gt 100 ]; then
    terminate "Input error in sixth parameter! Size can\`t be over 100kb"
  fi
}
