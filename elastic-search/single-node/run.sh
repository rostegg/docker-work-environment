#!/bin/bash

clear

EX_PATH="$( cd "$(dirname "$0")" ; pwd -P )/docker-compose.yml"
DATA_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
# fix max virtual memory areas vm.max_map_count [65530] is too low
sudo sysctl -w vm.max_map_count=262144

# gain permission for evere node data dir
mkdir ${DATA_PATH}/data
mkdir ${DATA_PATH}/data/lm_es_dev1
chown 1000:1000 ${DATA_PATH}/data*
chmod g+rwx ${DATA_PATH}/data*
chgrp 1000 ${DATA_PATH}/data*

read -e -p $'\e[32mRun as daemon? ("NO" by default):\e[0m ' DAEMON_MODE

if [ -z "$DAEMON_MODE" ]
then
    docker-compose -f $EX_PATH up  
else
    docker-compose -f $EX_PATH up -d 
fi
