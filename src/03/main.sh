#!/bin/bash
source scrape_sysinfo.sh
source parameters_validation.sh
source colours_list.sh


parameters=$@

validate_input_format       ${parameters[*]}
validate_args_count         ${parameters[*]}
check_no_colour_coincidence ${parameters[*]}

scrape_sysinfo | awk -v f1="${font_col[$1]}"\
                     -v b1="${back_col[$2]}"\
                     -v f2="${font_col[$3]}"\
                     -v b2="${back_col[$4]}"\
                     -v fd="${font_col[0]}" \
                     -v bd="${back_col[0]}" \
                     '{printf("%s%s%s%s%s = %s%s%s%s%s\n", f1,b1,$1,fd,bd, f2,b2,$3,fd,bd);}'
