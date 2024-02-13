function echoerr {
  >&2 echo "$@"
}

function terminate {
  echoerr "Error: incorrect input"
  echoerr $1
  exit 1
}

bold=$(tput bold)
normal=$(tput sgr0)
tabs 6
function print_usage {
  echo "${bold}DESCRIPTION${normal}"
  echo -e "\tThe script creates file folders in different (any, except paths\n"\
          "\tcontaining bin or sbin) locations on the file system. The\n" \
          "\tnumber of subfolders is up to 100, the number of files in each\n" \
          "\tfolder is a random number (different for each folder). The\n" \
          "\tscript should stop running when there is 1GB of free space left\n"\
          "\ton the file system (in the / partition)."
  echo
  echo "${bold}USAGE${normal}"
  echo -e '\tParameter 1 - the list of English alphabet letters used in\n' \
          '\t              folder names (no more than 7 characters).'
  echo -e '\tParameter 2 - the list of English alphabet letters used in the\n' \
          '\t              file name and extension (no more than 7\n' \
          '\t              characters for the name, no more than 3 for the \n' \
          '\t              extension).'
  echo -e '\tParameter 3 - the file size (in Megabytes, but not more than 100).'
  echo
  echo "${bold}EXAMPLE${normal}"
  echo -e '\tmain.sh ab cd.ef 3Mb'
}

function validate_input {
  # argument count
  if [ $arg_count -eq 0 ]; then
    print_usage
    exit 0; fi
  if [ $arg_count -ne 3 ]; then
    terminate "The script takes exactly 3 arguments as input"; fi
  
  # first parameter
  re_repeated_characters='\(.\).*\1'
  re_dir_letters='^[A-Za-z]{1,7}$'
  if [[ ! $dir_letters =~ $re_dir_letters ]]; then
    terminate "The first parameter, the folder's name, must contain no more \
               than 7 characters of English alphabet"; fi
  if echo "$dir_letters" | grep -q $re_repeated_characters ; then  
    terminate "The first parameter, the folder's name, should not contain \
               repetition of characters"; fi

  # second parameter
  re_file_name='^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$'
  if [[ ! $file_letters =~ $re_file_name ]]; then
    terminate "The second parameter, a file\`s name, must contain only A-z, \
               a-z letters and you can use not more 7 letters for a name and \
               not more 3 letters for \
               an extension. Letters in a name and in an extension can\`t \
               repeat. Example: sdf.ex"; fi
  if echo "$bn_letters" | grep -q $re_repeated_characters ; then  
    terminate "In the second parameter, a file\`s basename, should not contain \
               repetition of characters"; fi
  if echo "$ext_letters" | grep -q $re_repeated_characters ; then  
    terminate "In the second parameter, a file\`s extension, should not contain \
               repetition of characters"; fi

  # third parameter
  re_file_size_mib='^0*[1-9][0-9]*[mM][bB]$'
  if [[ ! $file_size_mib =~ $re_file_size_mib ]]; then
    terminate "The third parameter, the file size, must be in mb and has \
               at least 1 as a value. Example: 23mb."; fi
  file_size_mib=$(echo $file_size_mib | sed 's/'[mM][bB]'//')
  if [ $file_size_mib -gt 100 ]; then
    terminate "The third parameter, the file size, can\`t be over 100mb"; fi
}
