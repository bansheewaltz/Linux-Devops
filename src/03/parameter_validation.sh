function echoerr {
  >&2 echo "$@"
}

function terminate {
  echoerr "Error: incorrect input"
  echoerr $1
  exit 1
}

tabs 6
bold=$(tput bold)
normal=$(tput sgr0)
function print_usage {
  echo "${bold}DESCRIPTION${normal}"
  echo -e "\tThe script clears the system from the folders and files created\n"\
          "\tin Part 2 in 3 ways, which is defined by the input parameter."
  echo
  echo "${bold}USAGE${normal}"
  echo -e "\tOne parameter:\n" \
          "\t1  By log file\n" \
          "\t2  By creation date and time\n" \
          "\t3  By name mask (i.e. characters, underlining and date)."
  echo
  echo "${bold}EXAMPLE${normal}"
  echo -e '\tmain.sh 1'
}

function validate_parameter {
  # argument count
  if [ $arg_count -eq 0 ]; then
    print_usage
    exit 0;
  fi
  
  if [ $arg_count -ne 1 ]; then
    terminate "The script takes exactly 1 arguments as input"; fi
  
  re_parameter='^[1-3]$'
  if [[ ! $method =~ $re_parameter ]]; then
    terminate "The parameter value should be in a range of 1-3 accordingly to \
               a number of cleanup methods."
  fi
}
