#!/bin/bash

docker kill cluster_lm_kafka1_dev_1
docker kill cluster_lm_kafka2_dev_1
docker kill cluster_lm_zoo1_dev_1
docker kill cluster_lm_zoo2_dev_1

read -e -p $'\e[31mRemove data folder? ("NO" by default):\e[0m ' REMOVE_DATA

if [ ! -z "$REMOVE_DATA" ]
then
    DATA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/data"
    sudo rm -rf $DATA_DIR
fi
