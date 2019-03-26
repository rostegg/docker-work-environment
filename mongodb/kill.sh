#!/bin/bash

docker kill mongodb_mongo_dev_1
docker kill mongodb_mongo_express_1

read -e -p $'\e[31mRemove data folder? ("NO" by default):\e[0m ' REMOVE_DATA

if [ ! -z "$REMOVE_DATA" ]
then
    DATA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/data"
    sudo rm -rf $DATA_DIR
fi
