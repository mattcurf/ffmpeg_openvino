#!/bin/bash
docker build --network=host $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/--build-arg /') -t ffmpeg_ubuntu:18.04 .
