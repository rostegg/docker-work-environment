#!/bin/bash

clear

read -e -p $'\e[32mRun as daemon? ("NO" by default):\e[0m ' DAEMON_MODE

# fix max virtual memory areas vm.max_map_count [65530] is too low
sudo sysctl -w vm.max_map_count=262144

# gain permission for evere node data dir
mkdir data
mkdir data/lm_es_dev1_seed
mkdir data/lm_es_dev2
chown 1000:1000 data*
chmod g+rwx data*
chgrp 1000 data*

if [ -z "$DAEMON_MODE" ]
then
    docker-compose up 
else
    docker-compose up -d 
fi
