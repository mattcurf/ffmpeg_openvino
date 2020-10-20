FROM ubuntu:20.04 AS base
WORKDIR /build

# Install prerequisites
ARG TZ=America/New_York
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
   apt-get install -y -q --no-install-recommends \
      apt-utils \
      build-essential \
      ca-certificates \
      cmake \
      cpio \
      curl \
      git \
      gnupg-agent \
      libdrm-dev \
      libpciaccess-dev \
      libva-dev \
      libx11-dev \
      libx11-xcb-dev \
      libxcb-dri3-dev \
      libxcb-present-dev \
      lsb-release \
      nasm \
      pkg-config \
      software-properties-common \
      wget \
      xorg-dev \
      xutils-dev \
      yasm 

# OpenCL & VAAPI
RUN DEBIAN_FRONTEND=noninteractive && \
   curl -L https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - && \
   apt-add-repository 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main' && \
   apt-get update && \
   apt-get install -y -q --no-install-recommends \
     clinfo \
     intel-opencl-icd \
     intel-media-va-driver-non-free

# OpenVINO
ARG OpenVINO_VERSION=2021.1.110
RUN curl -L http://registrationcenter-download.intel.com/akdlm/irc_nas/17062/l_openvino_toolkit_p_2021.1.110.tgz | tar xzf - && \
    cd l_openvino_toolkit_p_${OpenVINO_VERSION} && \
    sed -i 's#decline#accept#g' silent.cfg && \
    ./install.sh -s silent.cfg 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino_2021/inference_engine/lib/intel64:/opt/intel/openvino_2021/inference_engine/external/tbb/lib:/opt/intel/openvino_2021/deployment_tools/ngraph/lib

# Workaround: OpenVINO installs MSDK, which breaks OpenCL
RUN rm /etc/ld.so.conf.d/intel-mediasdk.conf && ldconfig

# FFmpeg
RUN git clone --depth=1 https://github.com/FFmpeg/FFmpeg ffmpeg && \
   cd ffmpeg && \
   export PKG_CONFIG_PATH=/usr/lib/pkgconfig:${PKG_CONFIG_PATH} && \
   ./configure \
            --cpu=native \
            --extra-cflags=-I/opt/intel/openvino_2021/inference_engine/include/ \
            --extra-ldflags=-L/opt/intel/openvino_2021/inference_engine/lib/intel64 \
            --extra-libs=-lpthread \
            --disable-cuda-llvm \
            --prefix=/usr \
            --enable-static \
            --disable-shared \
            --enable-pic  \
            --disable-doc \
            --disable-manpages  \
            --enable-libopenvino \
            --enable-vaapi \
            --enable-gpl \
            --enable-nonfree \
            --enable-libxcb && \
   make -j $(nproc) && \
   make install

# Cleanup and environment
RUN rm -rf /build && \
   echo 'LIBVA_DRIVER_NAME=iHD' >> /etc/environment && \
   ldconfig

RUN wget https://raw.githubusercontent.com/guoyejun/dnn_processing/master/models/espcn.xml && \
    wget https://raw.githubusercontent.com/guoyejun/dnn_processing/master/models/espcn.bin && \
    wget https://raw.githubusercontent.com/guoyejun/dnn_processing/master/models/480p.mp4
