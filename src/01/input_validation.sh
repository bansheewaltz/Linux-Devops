function echoerr {
  >&2 echo "$@"
}

function terminate {
  echoerr "Error: incorrect input"
  echoerr $1
  exit 1
}

function print_usage {
  echo Usage:
  echo -e '\tParameter 1 is the absolute path.'
  echo -e '\tParameter 2 is the number of subfolders.'
  echo -e '\tParameter 3 is a list of English alphabet letters used in folder' \
            'names (no more than 7 characters).'
  echo -e '\tParameter 4 is the number of files in each created folder.'
  echo -e '\tParameter 5 - the list of English alphabet letters used in the ' \
            'file name and extension (no more than 7 characters for the' \
            'name, no more than 3 characters for the extension).'
  echo -e '\tParameter 6 - file size (in kilobytes, but not more than 100).'
  echo
  echo Example:
  echo -e '\tmain.sh /home/01/test 5 ab 13 cd.ef 3kb'
}

function validate_input {
  # argument count
  if [ $arg_count -eq 0 ]; then
    print_usage
    exit 1; fi
  if [ $arg_count -ne 6 ]; then
    terminate "The script takes exactly 6 arguments as input"; fi
  
  # first parameter
  re_abs_path='^/[a-zA-Z0-9/_-]*[^/]$'
  re_root='^/$'
  if [[ ! $path =~ $re_abs_path && ! $path =~ $re_root ]]; then
    terminate "The first parameter, the path, must be an absolute path to a \
               directory, without \"/\" in the end"; fi
  if [[ ! -d $path ]]; then
    terminate "The '$path' directory does not exist"; fi
  if [[ ! -w $path ]]; then
    terminate "Permission denied for '$path'"; fi
  
  # second parameter
  re_subdir_count='^0*[1-9][0-9]*$'
  if [[ ! $dir_count =~ $re_subdir_count ]]; then
    terminate "The second parameter, the folder count, accepts only numbers \
               and the value should be at least 1"; fi  

  # third parameter
  re_repeated_characters='\(.\).*\1'
  re_dir_letters='^[A-Za-z]{1,7}$'
  if [[ ! $dir_letters =~ $re_dir_letters ]]; then
    terminate "The third parameter, the folder's name, must contain no more \
               than 7 characters of English alphabet"; fi
  if echo "$dir_letters" | grep -q $re_repeated_characters ; then  
    terminate "The third parameter, the folder's name, should not contain \
               repetition of characters"; fi

  # fourth parameter
  re_file_count='^0*[1-9][0-9]*$'
  if [[ ! $file_count =~ $re_file_count ]]; then
    terminate "The fourth parameter, the file count, accepts only numbers \
               and the value should be at least 1"; fi 

  # fifth parameter
  re_file_name='^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$'
  if [[ ! $file_letters =~ $re_file_name ]]; then
    terminate "The fifth parameter, a file\`s name, must contain only A-z, \
               a-z letters and you can use not more 7 letters for a name and \
               not more 3 letters for \
               an extension. Letters in a name and in an extension can\`t \
               repeat. Example: sdf.ex"; fi
  if echo "$bn_letters" | grep -q $re_repeated_characters ; then  
    terminate "In the fifth parameter, a file\`s basename, should not contain \
               repetition of characters"; fi
  if echo "$ext_letters" | grep -q $re_repeated_characters ; then  
    terminate "In the fifth parameter, a file\`s extension, should not contain \
               repetition of characters"; fi

  # sixth parameter
  re_file_size_kib='^0*[1-9][0-9]*[kK][bB]$'
  if [[ ! $file_size_kib =~ $re_file_size_kib ]]; then
    terminate "The sixth parameter, the file size, must be in kb and has \
               at least 1 as a value. Example: 23kb."; fi
  file_size_kib=$(echo $file_size_kib | sed 's/'[kK][bB]'//')
  if [ $file_size_kib -gt 100 ]; then
    terminate "The sixth parameter, the file size, can\`t be over 100kb"; fi
}
