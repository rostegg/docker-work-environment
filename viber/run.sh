#!/bin/bash
sudo docker run -it -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -v /run/dbus/:/run/dbus/ -v=/dev/video0:/dev/video0 -v /dev/shm:/dev/shm --privileged rostegg/viber
