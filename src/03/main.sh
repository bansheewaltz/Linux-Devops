#!/bin/bash
source scrape_sysinfo.sh

# Validate the format of command-line arguments.
for parameter in "$@"
do
	if ! [[ "$parameter" =~ ^[1-6]$ ]]; then
		echo "Error: the script command-line arguments should be in the range [1-6]"
		exit 1
	fi
done
# Validate the number of command-line arguments.
if [ "$#" -ne 4 ]; then
	echo "Error: the script needs 4 parameters to run. Entered $#"
	exit 1
fi
# Check that there is no coincidence between foreground and background values
if [[ $1 == $2 || $3 == $4 ]]; then
  echo "Error: Colours of the foreground and the background should not coincise"
  echo "You can try again, but make sure that the first and the third values do not match the second and the fourth respectively"
fi
