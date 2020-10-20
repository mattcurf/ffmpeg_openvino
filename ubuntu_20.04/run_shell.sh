#!/bin/bash

docker run -it --rm -v `pwd`:`pwd` -w `pwd` --device /dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY ffmpeg_ubuntu:20.04 

