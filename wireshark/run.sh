#!/bin/bash
sudo docker run -it -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --net=host --privileged rostegg/wireshark
