#!/bin/bash

docker kill collectd_grafana_1
docker kill collectd_chronograf_1
docker kill collectd_collectd_1
docker kill collectd_influxdb_1


read -e -p $'\e[31mRemove data folder? ("NO" by default):\e[0m ' REMOVE_DATA

if [ ! -z "$REMOVE_DATA" ]
then
    DATA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/data"
    sudo rm -rf $DATA_DIR
fi