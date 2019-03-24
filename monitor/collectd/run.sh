#!/bin/bash

read -e -p $'\e[32mRun as daemon? ("NO" by default):\e[0m ' DAEMON_MODE

if [ -z "$DAEMON_MODE" ]
then
    sudo docker-compose up 
else
    sudo docker-compose up -d 
fi


