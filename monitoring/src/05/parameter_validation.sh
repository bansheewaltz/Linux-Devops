function echoerr {
  >&2 echo -e $@
}

function terminate {
  echoerr $@
  exit 1
}

tabs 6
bold=$(tput bold)
normal=$(tput sgr0)
function print_usage {
  echo "${bold}DESCRIPTION${normal}"
  echo -e "\tThe script parses nginx logs from Part 4 via awk."
  echo
  echo "${bold}USAGE${normal}"
  echo -e "\tOne parameter:\n" \
          "\t1  All entries sorted by response code.\n" \
          "\t2  All unique IPs found in the entries.\n" \
          "\t3  All requests with errors (response code - 4xx or 5xxx).\n" \
          "\t4  All unique IPs found among the erroneous requests."
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
  
  local re_parameter='^[1-4]$'
  if [[ ! $parameter =~ $re_parameter ]]; then
    terminate "Error: incorrect input" \
            "\nThe parameter value should be in a range of 1-4 accordingly to\
               a number of routines."
  fi

  if [ "$logs" = "" ]; then
    terminate "Error: nothing to parse" \
            "\nLog files are not found"
  fi
}
