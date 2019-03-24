#!/bin/bash

read -e -p $'\e[32mEnter work dir:\e[0m ' CODE_WORK_DIR
sudo docker run -t -p 127.0.0.1:8443:8443 -v "$CODE_WORK_DIR:/root/project" codercom/code-server --allow-http --no-auth
