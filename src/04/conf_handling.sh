print_conf_info(){
  source script.conf
  column1_background=${column1_background:=default}
  column1_font_color=${column1_font_color:=default}
  column2_background=${column2_background:=default}
  column2_font_color=${column2_font_color:=default}
  
  echo "Column 1 background = $column1_background" $(print_col_name $1)
  echo "Column 1 font color = $column1_font_color" $(print_col_name $2)
  echo "Column 2 background = $column2_background" $(print_col_name $3)
  echo "Column 2 font color = $column2_font_color" $(print_col_name $4)
}

print_col_name(){
  case "$1" in
    1) echo "(white)" ;;
    2) echo "(red)"   ;;
    3) echo "(green)" ;;
    4) echo "(blue)"  ;;
    5) echo "(purple)";;
    6) echo "(black)" ;;
  esac
}
