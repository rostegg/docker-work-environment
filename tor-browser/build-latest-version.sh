#!/bin/bash
TEMP_DATA=$(wget https://www.torproject.org/download/download-easy.html.en -q -O - |  tr -d '[:space:]')

VERSION=$(echo "$TEMP_DATA" | grep -o -P '(?<=\"torbrowserbundlelinux64\":\").*?(?=\"}\<\/span\>)')
echo ${VERSION}

sudo docker build --tag=rostegg/tor-browser --build-arg TOR_VERSION=${VERSION} .