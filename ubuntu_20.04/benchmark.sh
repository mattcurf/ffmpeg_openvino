#!/bin/bash

DOCKER="docker run --rm -v `pwd`:`pwd` -w `pwd` ffmpeg_ubuntu:20.04"

echo "*** CPU decode/encode, CPU inference"
$DOCKER ffmpeg -y -loglevel warning -hide_banner -stats -benchmark -i /build/480p.mp4 -vf format=yuv420p,dnn_processing=dnn_backend=openvino:model=/build/espcn.xml:input=x:output=espcn/prediction -y out1.mp4

# Run GPU if Intel graphics device present
if [ -n "$(lspci | grep 00.02.0)" ]; then
   DOCKER="docker run --rm -v `pwd`:`pwd` -w `pwd` --device /dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY ffmpeg_ubuntu:20.04"

   echo "*** CPU decode/encode, GPU inference"
   $DOCKER ffmpeg -y -loglevel warning -hide_banner -stats -benchmark -i /build/480p.mp4 -vf format=yuv420p,dnn_processing=dnn_backend=openvino:model=/build/espcn.xml:input=x:output=espcn/prediction:options=device=GPU -y out2.mp4

   echo "*** GPU decode/encode, CPU inference"
   $DOCKER ffmpeg -y -loglevel warning -hide_banner -stats -benchmark -hwaccel vaapi -hwaccel_output_format vaapi -i /build/480p.mp4 -vf hwdownload,format=yuv420p,dnn_processing=dnn_backend=openvino:model=/build/espcn.xml:input=x:output=espcn/prediction,format=nv12,hwupload -c:v h264_vaapi out3.mp4

   echo "*** GPU decode/encode, GPU inference"
   $DOCKER ffmpeg -y -loglevel warning -hide_banner -stats -benchmark -hwaccel vaapi -hwaccel_output_format vaapi -i /build/480p.mp4 -vf hwdownload,format=yuv420p,dnn_processing=dnn_backend=openvino:model=/build/espcn.xml:input=x:output=espcn/prediction:options=device=GPU,format=nv12,hwupload -c:v h264_vaapi out4.mp4
fi

