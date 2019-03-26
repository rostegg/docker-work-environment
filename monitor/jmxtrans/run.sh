#!/bin/bash

# TODO network setting for connecting jmx outside docker network

clear

read -e -p $'\e[32mRun as daemon? ("NO" by default):\e[0m ' DAEMON_MODE

if [ -z "$DAEMON_MODE" ]
then
    docker-compose up 
else
    docker-compose up -d 
fi
