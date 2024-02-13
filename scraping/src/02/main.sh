#!/bin/bash
source scrape_sysinfo.sh


info=$(scrape_sysinfo)
echo -e "$info\n"

read -p "Do you want to write the data to a file? [Y/n]" answer
if [[ "$answer" =~ [yY] ]]; then
	filename="$(date +"%d_%m_%y_%H_%M_%S").status"
	echo "$info" > "$filename"
fi
