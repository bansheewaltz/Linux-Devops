#!/bin/bash

### CPU
# idle_time=`cat /proc/stat | grep cpu | awk 'NR==1{print $5}'`
# total_time=`cat /proc/stat | grep cpu | awk 'NR==1 {print $2+$3+$4+$5+$6+$7+$8+$9+$10}'`
#CPU_USAGE=$(echo "scale=2; 100 * ($TOTAL_TIME - $IDLE_TIME) / $TOTAL_TIME" | bc)
# cpu_usage=`echo "$total_time $idle_time" | awk '{printf "%.3f", 100 * ($1 - $2) / $1}'`
cpu_usage=`cat /sys/fs/cgroup/cpu.stat | head -1 | cut -d" " -f2 | awk '{printf "%.3f", $1/1000000}'`
entry=s21_container_cpu_usage_seconds_total
echo \# HELP $entry CPU usage.
echo \# TYPE $entry gauge
echo $entry $cpu_usage

### memory
mem_limit=`cat /sys/fs/cgroup/memory.max`
entry=s21_container_memory_limit_bytes
echo \# HELP $entry Memory limit.
echo \# TYPE $entry gauge
echo $entry $mem_limit

mem_usage=`cat /sys/fs/cgroup/memory.current`
entry=s21_container_memory_usage_bytes
echo \# HELP $entry Used memory.
echo \# TYPE $entry gauge
echo $entry $mem_usage

mem_free=`echo $mem_limit $mem_usage | awk '{print $1-$2}'`
entry=s21_container_memory_free_bytes
echo \# HELP $entry Free memory.
echo \# TYPE $entry gauge
echo $entry $mem_free

### container FS
fs_usage=`du -s --block-size=1 / 2>/dev/null | cut -f1`
entry=s21_container_fs_usage_bytes
echo \# HELP $entry Number of bytes that are consumed by the container on this filesystem.
echo \# TYPE $entry gauge
echo $entry $fs_usage

fs_limit=$mem_limit
entry=s21_container_fs_limit_bytes
echo \# HELP $entry Number of bytes that can be consumed by the container on this filesystem.
echo \# TYPE $entry gauge
echo $entry $fs_limit

fs_free=`echo $fs_limit $fs_usage | awk '{print $1-$2}'`
entry=s21_container_fs_free_bytes
echo \# HELP $entry Number of bytes that can be consumed by the container on this filesystem.
echo \# TYPE $entry gauge
echo $entry $fs_free
