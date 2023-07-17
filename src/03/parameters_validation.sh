validate_input_format() {
	for parameter in "$@"
	do
		if ! [[ "$parameter" =~ ^[1-6]$ ]]; then
			echo "Error: the script command-line arguments should be values in the range [1-6]"
			exit 1
		fi
	done
}

validate_args_count(){
	if [ $# -ne 4 ]; then
		echo "Error: the script needs 4 parameters to run. Entered $#"
		exit 1
	fi
}

check_no_colour_coincidence(){
  if [[ $1 == $2 || $3 == $4 ]]; then
    echo "Error: Colours of the foreground and the background should not coincise"
    echo "You can try again, but make sure that the first and the third values do not match the second and the fourth respectively"
    exit 1
	fi
}
