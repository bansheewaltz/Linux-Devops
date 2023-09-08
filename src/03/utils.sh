function is_in_docker {
  if [ -f /.dockerenv ]; then
      return 0
  else
      return 1
  fi
}

function get_free_space_B {
  if is_in_docker; then
    memory_max=$(cat /sys/fs/cgroup/memory.max)
    memory_cur=$(du -s --block-size=1 / 2> /dev/null | cut -f1)
    # memory_free=$(awk -v a="$memory_max" -v b="$memory_cur" 'BEGIN { print (a - b)/1024 }') #kib
    memory_free=$((memory_max - memory_cur))
    echo $memory_free
  else 
    echo $(df -k / | awk '{ kib=$4; if (NR==2) print kib * 1024; }')
  fi
}

function format_bytes_output() {
  echo $(numfmt --to=iec-i --suffix=B --format="%9.2f" $1)
  # awk '
  #   function human(x) {
  #       if (x<1000) {return x} else {x/=1024}
  #       s="kMGTEPZY";
  #       while (x>=1000 && length(s)>1)
  #           {x/=1024; s=substr(s,2)}
  #       return int(x+0.5) substr(s,1,1)
  #   }
  #   {sub(/^[0-9]+/, human($1)); print}'
}

function cleanup() {
  files=$@
  filefolders=$(echo "$files" | xargs dirname | uniq)
  
  space_before=$(get_free_space_B)
  echo "$filefolders" | xargs rm -rf 2>/dev/null
  space_after=$(get_free_space_B)
  space_cleaned=$((space_after - space_before))
  
  echo
  echo $(echo "$filefolders" | wc -l) folders, total \
       $(echo "$files" | wc -l) files removed, \
       $(format_bytes_output $space_cleaned) of memory freed
}
