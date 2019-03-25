#!/bin/bash
docker run -it -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --privileged rostegg/tor-browser
