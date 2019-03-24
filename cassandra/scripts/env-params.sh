#!/bin/bash
clear
echo -e "\033[0;32mThis is how Cassandra will determine its default Heap and GC Generation sizes.\033[0;0m"

declare -i SYSTEM_MEMORY_MB=$(free -m | awk '/^Mem:/{print $2}')
declare -i HALF_SYSTEM_MEMORY_MB=$(( $SYSTEM_MEMORY_MB / 2 ))
declare -i QUARTER_SYSTEM_MEMORY_MB=$(( $HALF_SYSTEM_MEMORY_MB / 2 ))
declare -i SYSTEM_CPU_CORES=$(cat /proc/cpuinfo | grep -i processor | wc -l)
echo -e "  Memory = \033[0;32m${SYSTEM_MEMORY_MB}Mb\033[0;0m"
echo -e "  Half = \033[0;32m${HALF_SYSTEM_MEMORY_MB}Mb\033[0;0m"
echo -e "  Quarter = \033[0;32m${QUARTER_SYSTEM_MEMORY_MB}Mb\033[0;0m"
echo -e "  CPU cores = \033[0;32m${SYSTEM_CPU_CORES}\033[0;0m"

if [ "$HALF_SYSTEM_MEMORY_MB" -gt "1024" ]
then
    HALF_SYSTEM_MEMORY_MB="1024"
fi

if [ "$QUARTER_SYSTEM_MEMORY_MB" -gt "8192" ]
then
    QUARTER_SYSTEM_MEMORY_MB="8192"
fi

if [ "$HALF_SYSTEM_MEMORY_MB" -gt "$QUARTER_SYSTEM_MEMORY_MB" ]
then
    MAX_HEAP_SIZE_MB="$HALF_SYSTEM_MEMORY_MB"
else
    MAX_HEAP_SIZE_MB="$QUARTER_SYSTEM_MEMORY_MB"
fi

# Young gen: min(max_sensible_per_modern_cpu_core * num_cores, 1/4 * heap size)
declare -i MAX_SENSIBLE_YG_PER_CORE_MB=100
declare -i MAX_SENSIBLE_YG_MB=$(( MAX_SENSIBLE_YG_PER_CORE_MB * SYSTEM_CPU_CORES ))
declare -i DESIRED_YG_MB=$(( MAX_HEAP_SIZE_MB / 4 ))
if [ "$DESIRED_YG_MB" -gt "$MAX_SENSIBLE_YG_MB" ]
then
    HEAP_NEWSIZE_MB="${MAX_SENSIBLE_YG_MB}"
else
    HEAP_NEWSIZE_MB="${DESIRED_YG_MB}"
fi

echo -e "Max heap size = \033[0;32m${MAX_HEAP_SIZE_MB}Mb\033[0;0m" 
echo -e "New gen size = \033[0;32m${HEAP_NEWSIZE_MB}Mb\033[0;0m" 