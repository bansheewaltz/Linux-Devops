#!/bin/bash
source system_scraping.sh
source parameters_validation.sh
source colours_list.sh
source conf_handling.sh


source script.conf
parameters=(
  ${column1_background:=3}
  ${column1_font_color:=6}
  ${column2_background:=4} 
  ${column2_font_color:=1}
)

validate_input_format       ${parameters[*]}
validate_args_count         ${parameters[*]}
check_no_colour_coincidence ${parameters[*]}

scrape_sysinfo | awk -v f1="${font_col[$column1_font_color]}"\
                     -v b1="${back_col[$column1_background]}"\
                     -v f2="${font_col[$column2_font_color]}"\
                     -v b2="${back_col[$column2_background]}"\
                     -v fd="${font_col[0]}" \
                     -v bd="${back_col[0]}" \
                     '{printf("%s%s%s%s%s = %s%s%s%s%s\n", f1,b1,$1,fd,bd, f2,b2,$3,fd,bd);}'
echo
print_conf_info ${parameters[*]}
