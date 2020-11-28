#!/bin/bash

DOCKER="docker run --rm --device /dev/dri:/dev/dri ffmpeg_ubuntu:18.04"

echo "*** CPU decode/encode, CPU inference"
$DOCKER ffmpeg -loglevel warning -hide_banner -stats -benchmark -i 480p.mp4 -vf format=yuv420p,dnn_processing=dnn_backend=openvino:model=espcn.xml:input=x:output=espcn/prediction -y out1.mp4

# Run GPU if Intel graphics device present
if [ -n "$(lspci | grep 00.02.0)" ]; then
   echo "*** CPU decode/encode, GPU inference"
   $DOCKER ffmpeg -loglevel warning -hide_banner -stats -benchmark -i 480p.mp4 -vf format=yuv420p,dnn_processing=dnn_backend=openvino:model=espcn.xml:input=x:output=espcn/prediction:options=device=GPU -y out2.mp4

   echo "*** GPU decode/encode, CPU inference"
   $DOCKER ffmpeg -loglevel warning -hide_banner -stats -benchmark -hwaccel vaapi -hwaccel_output_format vaapi -i 480p.mp4 -vf hwdownload,format=yuv420p,dnn_processing=dnn_backend=openvino:model=espcn.xml:input=x:output=espcn/prediction,format=nv12,hwupload -c:v h264_vaapi -y out3.mp4

   echo "*** GPU decode/encode, GPU inference"
   $DOCKER ffmpeg -loglevel warning -hide_banner -stats -benchmark -hwaccel vaapi -hwaccel_output_format vaapi -i 480p.mp4 -vf hwdownload,format=yuv420p,dnn_processing=dnn_backend=openvino:model=espcn.xml:input=x:output=espcn/prediction:options=device=GPU,format=nv12,hwupload -c:v h264_vaapi -y out4.mp4
fi
